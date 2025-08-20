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

  <#-- Client-side email domain validation: only @pnj.ac.id and subdomains -->
    <script nonce="${cspNonce}">
      (function () {
        var form = document.getElementById('kc-update-email-form');
        if (!form) return;
        var email = form.querySelector('input[name="email"], input#email, input[type="email"]');
        if (!email) return;

        // Allow @pnj.ac.id or any *.pnj.ac.id (case-insensitive)
        var allowed = /@(?:[A-Za-z0-9-]+\.)*pnj\.ac\.id$/i;

        // Progressive enhancement: HTML5 pattern + tooltip
        try {
          email.setAttribute('pattern', '^[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\\.)*pnj\\.ac\\.id$');
          email.setAttribute('title', 'Use your @pnj.ac.id address (subdomains like name@dept.pnj.ac.id are allowed).');
        } catch (e) {}

        function validate() {
          email.setCustomValidity('');
          var v = (email.value || '').trim();
          if (!v) return; // let "required" handle empties if applicable
          if (!allowed.test(v)) {
            email.setCustomValidity('Please use an @pnj.ac.id address (subdomains like name@dept.pnj.ac.id are allowed).');
          }
        }

        email.addEventListener('input', validate);
        form.addEventListener('submit', function (e) {
          validate();
          if (!form.checkValidity()) {
            e.preventDefault();
            if (email.reportValidity) email.reportValidity();
          }
        });
      })();
    </script>
  </#if>
</@layout.registrationLayout>
