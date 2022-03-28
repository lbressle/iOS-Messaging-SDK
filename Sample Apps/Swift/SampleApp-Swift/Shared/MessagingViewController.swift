//
//  ViewController.swift
//  SampleApp-Swift
//
//  Created by Nimrod Shai on 2/23/16.
//  Copyright © 2016 LivePerson. All rights reserved.
//

import UIKit
import LPMessagingSDK

class MessagingViewController: UIViewController {

    //MARK: - UI Properties
    @IBOutlet var accountTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var authenticationSwitch: UISwitch!

    private var authenticationSwitchValue: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "AuthenticationSwitch")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "AuthenticationSwitch")
        }
    }

    // always set to window mode
    private var conversationViewController: ConversationViewController? = nil

    // Enter Your Code if using Autherization type 'Code'
    private let authenticationCode: String? = nil

    // Enter Your JWT if using Autherization type 'Implicit'
    private let authenticationJWT: String? = nil

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Enter Your Account Number
        self.accountTextField.text = "74782401"
        self.authenticationSwitch.isOn = authenticationSwitchValue

        LPMessaging.instance.delegate = self
        setLPConfigs()
        LPMessaging.instance.setLoggingLevel(level: .INFO)
    }

    //MARK: - IBActions
    @IBAction func resignKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func authenticationSwitchChanged(_ sender: UISwitch) {
        authenticationSwitchValue = sender.isOn
    }

    @IBAction func initSDKsClicked(_ sender: Any) {
        defer {
            self.view.endEditing(true)
        }

        guard let accountNumber = self.accountTextField.text, !accountNumber.isEmpty else {
            print("missing account number!")
            return
        }

        initLPSDKwith(accountNumber: accountNumber)
    }

    @IBAction func showConversation() {
        defer {
            self.view.endEditing(true)
        }

        guard let accountNumber = self.accountTextField.text, !accountNumber.isEmpty else {
            print("missing account number!")
            return
        }

        showConversationFor(accountNumber: accountNumber, authenticatedMode: authenticationSwitchValue)
    }

    @IBAction func logoutClicked(_ sender: Any) {
        logoutLPSDK()
    }
}

// MARK: - LPMessagingSDK Helpers
extension MessagingViewController {
    private func getUnreadMessageCount() {
        guard let accountNumber = self.accountTextField.text, !accountNumber.isEmpty else {
            print("missing account number!")
            return
        }

        let conversationQuery = LPMessaging.instance.getConversationBrandQuery(accountNumber)
        LPMessaging.instance.getUnreadMessagesCount(conversationQuery, completion: { (count) in
                    print("unread message count: \(count)")
                }) { (error) in
                    print("unread message count - error: \(error.localizedDescription)")
                }
    }

    /**
     This method initialize the messaging SDK

     for more information on `initialize` see:
         https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-apis-messaging-api.html#initialize
     */
    private func initLPSDKwith(accountNumber: String) {
        do {
            try LPMessaging.instance.initialize(accountNumber)
        } catch let error as NSError {
            print("initialize error: \(error)")
        }
    }

    /**
     This method shows the conversation screen. It considers different modes:

     Window Mode:
     - Window           - Shows the conversation screen in a new window created by the SDK. Navigation bar is included.
     - View controller  - Shows the conversation screen in a view controller of your choice.

     Authentication Mode:
     - Authenticated    - Conversation history is saved and shown.
     - Unauthenticated  - Conversation starts clean every time.

     for more information on `showconversation` see:
         https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-apis-messaging-api.html#showconversation
     */
    private func showConversationFor(accountNumber: String, authenticatedMode: Bool) {
        //ConversationParamProtocol
        let conversationQuery = LPMessaging.instance.getConversationBrandQuery(accountNumber)

        //LPConversationHistoryControlParam
        let controlParam = LPConversationHistoryControlParam(historyConversationsStateToDisplay: .all,
                historyConversationsMaxDays: -1,
                historyMaxDaysType: .startConversationDate)

        //LPAuthenticationParams
        var authenticationParams: LPAuthenticationParams?
        if authenticatedMode {
            authenticationParams = LPAuthenticationParams(authenticationCode: authenticationCode,
                    jwt: authenticationJWT,
                    redirectURI: nil,
                    certPinningPublicKeys: nil,
                    authenticationType: .authenticated)
        }

        //LPWelcomeMessageParam
        let lpWelcomeText = "Hello! I'm a UnitedHealthcare virtual assistant here to get you started. How can I help you today?"
        let welcomeMessageParam = LPWelcomeMessage(message: lpWelcomeText, frequency: .everyConversation)

        let welcomeMessageOptions = [
            LPWelcomeMessageOption(value: "COVID-19 Resources", displayName: "COVID-19 Resources"),
            LPWelcomeMessageOption(value: "Benefits", displayName: "Benefits"),
            LPWelcomeMessageOption(value: "Claims", displayName: "Claims"),
            LPWelcomeMessageOption(value: "Find a Provider", displayName: "Find a Provider"),
            LPWelcomeMessageOption(value: "Something Else", displayName: "Something Else"),
        ]

        do {
            try welcomeMessageParam.set(options: welcomeMessageOptions)
        } catch {
            print("cannot set welcome message options | error: \(error.localizedDescription)")
        }

        welcomeMessageParam.set(NumberOfOptionsPerRow: 2)

        //LPConversationViewParams
        let conversationViewParams = LPConversationViewParams(conversationQuery: conversationQuery,
                containerViewController: self.conversationViewController,
                isViewOnly: false,
                conversationHistoryControlParam: controlParam,
                welcomeMessage: welcomeMessageParam)

        LPMessaging.instance.showConversation(conversationViewParams, authenticationParams: authenticationParams)

        self.setUserDetails()
    }
    /**
     This method sets the user details such as first name, last name, profile image and phone number.

     for more info on `setUserProfile` see:
         https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-apis-messaging-api.html#setuserprofile
     */
    private func setUserDetails() {
        let user = LPUser(firstName: "Johnny",
                lastName: "S",
                nickName: "my nick name",
                uid: nil,
                profileImageURL: "http://www.mrbreakfast.com/ucp/342_6053_ucp.jpg",
                phoneNumber: nil,
                employeeID: "1111-1111")
        LPMessaging.instance.setUserProfile(user, brandID: self.accountTextField.text!)
    }

    /**
     This method logouts from Monitoring and Messaging SDKs - all the data will be cleared

     for more info on `logout` see:
         https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-methods-logout.html
     */
    private func logoutLPSDK() {
        LPMessaging.instance.logout(unregisterType: .all, completion: {
                    print("successfully logout from MessagingSDK")
                }) { (errors) in
                    print("failed to logout from MessagingSDK - error: \(errors)")
                }
    }
}

//MARK: - LPMessagingSDKdelegate

/**
 for more info on `LPMessagingSDKdelegate` see:
     https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-apis-callbacks-index.html#lpmessagingsdkdelegate
 */
extension MessagingViewController: LPMessagingSDKdelegate {

    /**
    This delegate method is required.
    It is called when authentication process fails
    */
    func LPMessagingSDKAuthenticationFailed(_ error: NSError) {
        NSLog("Error: \(error)")
    }

    /**
    This delegate method is required.
    It is called when the SDK version you're using is obselete and needs an update.
    */
    func LPMessagingSDKObseleteVersion(_ error: NSError) {
        NSLog("Error: \(error)")
    }

    /**
    This delegate method is optional.
    It is called each time the SDK receives info about the agent on the other side.

    Example:
    You can use this data to show the agent details on your navigation bar (in view controller mode)
    */
    func LPMessagingSDKAgentDetails(_ agent: LPUser?) {
        guard self.conversationViewController != nil else {
            return
        }

        //let name: String = agent?.nickName ?? "Help Chat"
        //self.conversationViewController?.title = name
    }

    /**
    This delegate method is optional.
    It is called each time the SDK menu is opened/closed.
    */
    func LPMessagingSDKActionsMenuToggled(_ toggled: Bool) {

    }

    /**
    This delegate method is optional.
    It is called each time the agent typing state changes.
    */
    func LPMessagingSDKAgentIsTypingStateChanged(_ isTyping: Bool) {

    }

    /**
    This delegate method is optional.
    It is called after the customer satisfaction page is submitted with a score.
    */
    func LPMessagingSDKCSATScoreSubmissionDidFinish(_ accountID: String, rating: Int) {

    }

    /**
    This delegate method is optional.
    If you set a custom button, this method will be called when the custom button is clicked.
    */
    func LPMessagingSDKCustomButtonTapped() {

    }

    /**
    This delegate method is optional.
    It is called whenever an event log is received.
    */
    func LPMessagingSDKDidReceiveEventLog(_ eventLog: String) {

    }

    /**
    This delegate method is optional.
    It is called when the SDK has connections issues.
    */
    func LPMessagingSDKHasConnectionError(_ error: String?) {
        NSLog("Error: \(String(describing: error))")
    }

    /**
     This delegate method is required.
     It is called when the token which used for authentication is expired
     */
    func LPMessagingSDKTokenExpired(_ brandID: String) {
        NSLog("LPMessagingSDKTokenExpired")
    }

    /**
     This delegate method is required.
     It lets you know if there is an error with the sdk and what this error is
     */
    func LPMessagingSDKError(_ error: NSError) {
        NSLog("Error: \(error)")
    }

    /**
     This delegate method is optional.
     It is called when the conversation view controller removed from its container view controller or window.
     */
    func LPMessagingSDKConversationViewControllerDidDismiss() {

    }

    /**
     This delegate method is optional.
     It is called when a new conversation has started, from the agent or from the consumer side.
     */
    func LPMessagingSDKConversationStarted(_ conversationID: String?) {

    }

    /**
     This delegate method is optional.
     It is called when a conversation has ended, from the agent or from the consumer side.
     */
    func LPMessagingSDKConversationEnded(_ conversationID: String?) {

    }

    /**
     This delegate method is optional.
     It is called when the customer satisfaction survey is dismissed after the user has submitted the survey/
     */
    func LPMessagingSDKConversationCSATDismissedOnSubmittion(_ conversationID: String?) {

    }

    /**
     This delegate method is optional.
     It is called each time connection state changed for a brand with a flag whenever connection is ready.
     Ready means that all conversations and messages were synced with the server.
     */
    func LPMessagingSDKConnectionStateChanged(_ isReady: Bool, brandID: String) {

    }

    /**
     This delegate method is optional.
     It is called when the user tapped on the agent’s avatar in the conversation and also in the navigation bar within window mode.
     */
    func LPMessagingSDKAgentAvatarTapped(_ agent: LPUser?) {

    }

    /**
     This delegate method is optional.
     It is called when the Conversation CSAT did load
    */
    func LPMessagingSDKConversationCSATDidLoad(_ conversationID: String?) {

    }

    /**
     This delegate method is optional.
     It is called when the Conversation CSAT skipped by the consumer
     */
    func LPMessagingSDKConversationCSATSkipped(_ conversationID: String?) {

    }

    /**
     This delegate method is optional.
     It is called when the user is opening photo sharing gallery/camera and the persmissions denied
    */
    func LPMessagingSDKUserDeniedPermission(_ permissionType: LPPermissionTypes) {

    }
}
