//
//  LPConfig.swift
//  SampleApp
//
//  Created by Sit, Johnny on 3/25/22.
//  Copyright © 2022 LivePerson. All rights reserved.
//

import Foundation
import LPMessagingSDK

let uhcBlue = getColor(r: 0, g: 38, b: 119)
let configurations = LPConfig.defaultConfiguration

private func getGrey(color: Int) -> UIColor {
    return getColor(r: color, g: color, b: color)
}

private func getColor(r: Int, g: Int, b: Int) -> UIColor {
    return UIColor.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
}

/**
     This method sets the SDK configurations.

     For example:
         Change background color of remote user (such as Agent)
         Change background color of user (such as Consumer)

    for more information on `defaultConfiguration` see: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-customization-and-branding-customizing-the-sdk.html
*/
public func setLPConfigs(){
    setBrandConfig(configurations: configurations)
    setConversationConfig(configurations: configurations)
    setAgentConfig(configurations: configurations)
    setUserConfig(configurations: configurations)
    setSharingConfig(configurations: configurations)
    setInputBoxConfig(configurations: configurations)
    setSendButtonConfig(configurations: configurations)
    setTimestampConfig(configurations: configurations)
    setLinkPreviewConfig(configurations: configurations)
    setScrollToBottomConfig(configurations: configurations)
    setCSATConfig(configurations: configurations)
}

/**
 Sets brand config

 Docs: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-attributes-sdk-5-0-and-above.html#brand
*/
private func setBrandConfig(configurations: LPConfig){
    // font
    configurations.customFontNameConversationFeed = "SFProText-Regular"

    // brand avatar
    configurations.brandAvatarImage = UIImage(named: "UHC_Logo")

    // title bar
    configurations.brandName = "Help Chat"
    configurations.conversationNavigationBackgroundColor = uhcBlue
    configurations.conversationNavigationTitleColor = UIColor.white
    // configurations.lpNavigationBarLeftItemImageButton = UIImage(named: "back_icon") // TODO: Add back icon
    configurations.lpNavigationBarRightItemImageButton = UIImage(named: "meatball")
}

/**
 Sets conversation configs
 Docs: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-attributes-sdk-5-0-and-above.html#conversations
 */
private func setConversationConfig(configurations: LPConfig){
    configurations.conversationBackgroundColor = UIColor.white

    // conversation separator
    configurations.enableConversationSeparatorLineOnAutoClose = true
    configurations.conversationSeparatorTextColor = getColor(r: 204, g: 204, b: 204)
    configurations.conversationSeparatorFontName = "SFProText-Semibold"
}

/**
 Sets agent configs
 Docs: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-attributes-sdk-5-0-and-above.html#user-avatar
 */
private func setAgentConfig(configurations: LPConfig){
    configurations.remoteUserBubbleBackgroundColor = getColor(r: 243, g: 243, b: 243)
    configurations.remoteUserBubbleBorderColor = getColor(r: 243, g: 243, b: 243)
    configurations.remoteUserBubbleTextColor = getColor(r: 51, g: 51, b: 51)
    configurations.remoteUserTypingTintColor = getColor(r: 0, g: 38, b: 119)
    configurations.remoteUserBubbleHyperlinkColor = getColor(r: 25, g: 110, b: 207)
    configurations.remoteUserBubbleBottomLeftCornerRadius = 8

    //remote user typing bubble
    configurations.remoteUserTypingTintColor = uhcBlue

    // agent avatar
    configurations.remoteUserAvatarIconColor = uhcBlue
    configurations.remoteUserAvatarBackgroundColor = UIColor.white
}

/**
 Sets user configs
 Docs: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-attributes-sdk-5-0-and-above.html#users-bubble
 */
private func setUserConfig(configurations: LPConfig){
    configurations.userBubbleTextColor = getColor(r: 31, g: 31, b: 31)
    configurations.userBubbleBorderColor = getColor(r: 204, g: 204, b: 204)
    configurations.userBubbleBackgroundColor = UIColor.white
    configurations.userBubbleLinkColor = getColor(r: 25, g: 110, b: 207)
    configurations.userBubbleBottomRightCornerRadius = 8
}

/**
 Sets file and photo sharing configs
 Docs: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-attributes-sdk-5-0-and-above.html#photo-and-file-sharing
*/
private func setSharingConfig(configurations: LPConfig){
    configurations.fileSharingFromConsumer = true
    configurations.photosharingMenuBackgroundColor = uhcBlue
    configurations.photosharingMenuButtonsTintColor = uhcBlue
    configurations.cameraButtonEnabledColor = uhcBlue
    configurations.photosharingMenuButtonsTextColor = UIColor.white
    configurations.photosharingMenuButtonsBackgroundColor = UIColor.white
    configurations.photoSharingOpenMenuImageButton = UIImage(named: "file_attachment_icon")
    configurations.photoSharingMenuCameraImage = UIImage(named: "cameraIcon")
    configurations.fileSharingMenuFileImage = UIImage(named: "documentIcon")
}

/**
 Sets input text box configs
 Docs: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-attributes-sdk-5-0-and-above.html#user-input-view
*/
private func setInputBoxConfig(configurations: LPConfig){
    configurations.inputTextViewContainerBackgroundColor = getGrey(color: 242)
    configurations.inputTextViewTopBorderColor = getColor(r: 204, g: 204, b: 204)
    configurations.inputTextViewCornerRadius = 4
}

/**
 Sets send button configs
 Docs: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-attributes-sdk-5-0-and-above.html#send-button
 */
private func setSendButtonConfig(configurations: LPConfig){
    configurations.isSendMessageButtonInTextMode = false
    configurations.sendButtonImage = UIImage(named: "send_icon_alt")
    configurations.sendButtonEnabledColor = uhcBlue
}

/**
 Sets timestamp configs
 */
private func setTimestampConfig(configurations: LPConfig){
    configurations.messageStatusNumericTimestampOnly = true
    configurations.userBubbleTimestampColor = getColor(r: 90, g: 90, b: 90)
    configurations.remoteUserBubbleTimestampColor = getColor(r: 90, g: 90, b: 90)
}

/**
 Sets link preview configs
 Docs: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-attributes-sdk-5-0-and-above.html#link-preview
*/
private func setLinkPreviewConfig(configurations: LPConfig){
    configurations.linkPreviewBackgroundColor = UIColor.white
    configurations.urlRealTimePreviewBackgroundColor = UIColor.white
}

/**
 Sets scroll to bottom configs
 Docs: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-attributes-sdk-5-0-and-above.html#unread-messages
*/
private func setScrollToBottomConfig(configurations: LPConfig){
    configurations.scrollToBottomButtonBackgroundColor = uhcBlue
    configurations.scrollToBottomButtonMessagePreviewTextColor = UIColor.white
    configurations.scrollToBottomButtonArrowColor = UIColor.white
}

/**
 Sets CSAT configs
 Docs: https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-sdk-attributes-sdk-5-0-and-above.html#surveys-buttons-csat-and-fcr
*/
private func setCSATConfig(configurations: LPConfig){
    configurations.csatShowSurveyView = false
}
