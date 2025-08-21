<#import "template.ftl" as layout>
<#import "components/atoms/button.ftl" as button>
<#import "components/atoms/button-group.ftl" as buttonGroup>
<#import "components/atoms/form.ftl" as form>

<#-- Keep Keycloak's shared macros so fields/validation follow User Profile config -->
<#import "password-commons.ftl" as passwordCommons>
<#import "user-profile-commons.ftl" as userProfileCommons>

<@layout.registrationLayout
displayMessage=messagesPerField.exists('global')
displayRequiredFields=true
; section
>
  <#if section = "header">
    ${msg("updateEmailTitle")}
  <#elseif section = "form">
    <@form.kw id="kc-update-email-form" action=url.loginAction method="post">
      <@userProfileCommons.userProfileFormFields/>

      <@passwordCommons.logoutOtherSessions/>

      <@buttonGroup.kw>
        <#if isAppInitiatedAction??>
          <@button.kw color="primary" type="submit">
            ${msg("doSubmit")}
          </@button.kw>
          <@button.kw color="secondary" name="cancel-aia" type="submit" value="true">
            ${msg("doCancel")}
          </@button.kw>
        <#else>
          <@button.kw color="primary" type="submit">
            ${msg("doSubmit")}
          </@button.kw>
        </#if>
      </@buttonGroup.kw>
    </@form.kw>
  </#if>
</@layout.registrationLayout>
