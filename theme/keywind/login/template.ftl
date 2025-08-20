<#import "document.ftl" as document>
<#import "components/atoms/alert.ftl" as alert>
<#import "components/atoms/body.ftl" as body>
<#import "components/atoms/button.ftl" as button>
<#import "components/atoms/card.ftl" as card>
<#import "components/atoms/container.ftl" as container>
<#import "components/atoms/heading.ftl" as heading>
<#import "components/atoms/logo.ftl" as logo>
<#import "components/atoms/nav.ftl" as nav>
<#import "components/molecules/locale-provider.ftl" as localeProvider>
<#import "components/molecules/username.ftl" as username>

<#macro
  registrationLayout
  displayInfo=false
  displayMessage=true
  displayRequiredFields=false
  script=""
  showAnotherWayIfPresent=true
>
  <#assign cardHeader>
    <@logo.kw>
      ${kcSanitize(msg("loginTitleHtml", (realm.displayNameHtml!"")))?no_esc}
    </@logo.kw>
    <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
      <@heading.kw>
        <#nested "header">
      </@heading.kw>
    <#else>
      <#nested "show-username">
      <@username.kw
        linkHref=url.loginRestartFlowUrl
        linkTitle=msg("restartLoginTooltip")
        name=auth.attemptedUsername
      />
    </#if>
  </#assign>

  <#assign cardContent>
    <#if displayMessage && message?has_content && (message.type != "warning" || !isAppInitiatedAction??)>
      <@alert.kw color=message.type>
        ${kcSanitize(message.summary)?no_esc}
      </@alert.kw>
    </#if>
    <#nested "form">
    <#if displayRequiredFields>
      <p class="text-secondary-600 text-sm">
        * ${msg("requiredFields")}
      </p>
    </#if>
    <#if auth?has_content && auth.showTryAnotherWayLink() && showAnotherWayIfPresent>
      <form action="${url.loginAction}" method="post">
        <input name="tryAnotherWay" type="hidden" value="on" />
        <@button.kw color="secondary" type="submit">
          ${msg("doTryAnotherWay")}
        </@button.kw>
      </form>
    </#if>
    <#nested "socialProviders">
  </#assign>

  <#assign cardFooter>
    <#if displayInfo>
      <#nested "info">
    </#if>
  </#assign>

  <html<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>
    <head>
      <@document.kw script=script />
    </head>
    <@body.kw>
      <@container.kw>
        <div class="w-full sm:max-w-md bg-teal-100 border-t-4 border-teal-500 rounded-b text-teal-900 px-4 py-3 shadow-md" role="alert">
          <div class="flex">
            <div class="py-1">
              <svg class="fill-current h-6 w-6 text-teal-500 mr-4" xmlns="http://www.w3.org/2000/svg"
                   viewBox="0 0 20 20">
                <path
                  d="M2.93 17.07A10 10 0 1 1 17.07 2.93 10 10 0 0 1 2.93 17.07zm12.73-1.41A8 8 0 1 0 4.34 4.34a8 8 0 0 0 11.32 11.32zM9 11V9h2v6H9v-4zm0-6h2v2H9V5z"/>
              </svg>
            </div>
            <div>
              <p class="font-bold">${msg("migrationTitleMsg")}</p>
              <p class="text-sm">${msg("migrationTitleDesc")}
                <a class="underline" href="https://google.com">${msg("migrationTitleHere")}</a>.
              </p>
            </div>
          </div>
        </div>
        <@card.kw content=cardContent footer=cardFooter header=cardHeader />
        <@nav.kw>
          <#nested "nav">
          <#if realm.internationalizationEnabled && locale.supported?size gt 1>
            <@localeProvider.kw currentLocale=locale.current locales=locale.supported />
          </#if>
        </@nav.kw>
      </@container.kw>
    </@body.kw>
  </html>
</#macro>
