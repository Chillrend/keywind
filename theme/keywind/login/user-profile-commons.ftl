<#-- Your override: render dynamic User Profile fields with your input atom -->
<#import "components/atoms/input.ftl" as input>

<#-- The macro name/signature matches Keycloak's base so imports in pages keep working -->
<#macro userProfileFormFields>
<#-- Track current group to print group headers/descriptions once -->
  <#assign currentGroup = "">
  <#list profile.attributes as attribute>
  <#-- Group header/description (optional) -->
    <#assign group = (attribute.group)!"" >
    <#if group != currentGroup>
      <#assign currentGroup = group>
      <#if currentGroup != "">
        <div class="${properties.kcFormGroupClass!}"
          <#if group.html5DataAnnotations??>
            <#list group.html5DataAnnotations as key, value>
              data-${key}="${value}"
            </#list>
          </#if>
        >
          <#assign groupHeaderKey = (group.displayHeader)!"">
          <#if groupHeaderKey?has_content>
            <h2 class="${properties.kcContentWrapperClass!}__title">
              ${advancedMsg(groupHeaderKey)!group.name!""}
            </h2>
          </#if>
          <#assign groupDescKey = (group.displayDescription)!"">
          <#if groupDescKey?has_content>
            <p class="${properties.kcContentWrapperClass!}__subtitle">
              ${advancedMsg(groupDescKey)!""}
            </p>
          </#if>
        </div>
      </#if>
    </#if>

  <#-- Field basics -->
    <#assign fieldName = attribute.name>
    <#assign hasError  = messagesPerField.existsError(fieldName)>
    <#assign errorMsg  = kcSanitize(messagesPerField.get(fieldName))>
    <#assign labelText = (advancedMsg(attribute.displayName!'')!fieldName)>
    <#assign valueText = (attribute.value!'')>

  <#-- Decide type from annotations (html5-* maps to actual HTML5 type) -->
    <#assign typeAnn = (attribute.annotations.inputType!'')>
    <#if typeAnn?starts_with('html5-')>
      <#assign resolvedType = typeAnn[6..]>
    <#elseif typeAnn?has_content>
      <#assign resolvedType = typeAnn>
    <#else>
      <#assign resolvedType = 'text'>
    </#if>

    <div class="${properties.kcFormGroupClass!}"
      <#if attribute.html5DataAnnotations??>
        <#list attribute.html5DataAnnotations as key, value>
          data-${key}="${value}"
        </#list>
      </#if>
    >

      <#-- Optional helper text BEFORE the field -->
      <#if attribute.annotations.inputHelperTextBefore??>
        <p class="${properties.kcLabelClass!}">
          ${kcSanitize(advancedMsg(attribute.annotations.inputHelperTextBefore))?no_esc}
        </p>
      </#if>

      <#-- Give pages a hook to inject content around each field (keeps parity with base theme) -->
      <#nested "beforeField" attribute>

      <#-- Render control (prefer your input atom for typical single-value fields) -->
      <#if resolvedType?lower_case == 'textarea'>
        <div class="${properties.kcInputWrapperClass!}">
          <textarea
            id="${fieldName}"
            name="${fieldName}"
            <#if attribute.autocomplete??>autocomplete="${attribute.autocomplete}"</#if>
            <#if attribute.readOnly!false>disabled</#if>
            aria-invalid="<#if hasError>true</#if>"
          >${valueText}</textarea>
        </div>
        <#if hasError>
          <span class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
            ${errorMsg?no_esc}
          </span>
        </#if>

      <#elseif resolvedType?lower_case == 'select' || resolvedType?lower_case == 'multiselect'>
      <#-- Build options from validators (matches base logic) -->
        <#if attribute.annotations.inputOptionsFromValidation??
        && attribute.validators[attribute.annotations.inputOptionsFromValidation]??
        && attribute.validators[attribute.annotations.inputOptionsFromValidation].options??>
          <#assign options = attribute.validators[attribute.annotations.inputOptionsFromValidation].options>
        <#elseif attribute.validators.options?? && attribute.validators.options.options??>
          <#assign options = attribute.validators.options.options>
        <#else>
          <#assign options = []>
        </#if>

        <div class="${properties.kcInputWrapperClass!}">
          <select
            id="${fieldName}"
            name="${fieldName}"
            <#if resolvedType == 'multiselect'>multiple</#if>
            <#if attribute.readOnly!false>disabled</#if>
            aria-invalid="<#if hasError>true</#if>"
          >
            <#list options as option>
            <#-- Handle current value(s) -->
              <#assign selected = (attribute.values?? && attribute.values?seq_contains(option)) || (valueText == option)>
              <option value="${option}" <#if selected>selected</#if>>
                <#if attribute.annotations.inputOptionLabels??>
                  ${advancedMsg(attribute.annotations.inputOptionLabels[option]!option)}
                <#elseif attribute.annotations.inputOptionLabelsI18nPrefix??>
                  ${msg(attribute.annotations.inputOptionLabelsI18nPrefix + '.' + option)}
                <#else>
                  ${option}
                </#if>
              </option>
            </#list>
          </select>
        </div>
        <#if hasError>
          <span class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
            ${errorMsg?no_esc}
          </span>
        </#if>

      <#elseif resolvedType?lower_case == 'select-radiobuttons' || resolvedType?lower_case == 'multiselect-checkboxes'>
      <#-- Radios/checkboxes (fallback HTML; style via CSS) -->
        <#if attribute.annotations.inputOptionsFromValidation??
        && attribute.validators[attribute.annotations.inputOptionsFromValidation]??
        && attribute.validators[attribute.annotations.inputOptionsFromValidation].options??>
          <#assign options = attribute.validators[attribute.annotations.inputOptionsFromValidation].options>
        <#elseif attribute.validators.options?? && attribute.validators.options.options??>
          <#assign options = attribute.validators.options.options>
        </#if>
        <div class="${properties.kcInputWrapperClass!}">
          <#list options as option>
            <#assign isMulti = (resolvedType?lower_case == 'multiselect-checkboxes')>
            <#assign inputType = isMulti?string('checkbox', 'radio')>
            <#assign checked = (attribute.values?? && attribute.values?seq_contains(option)) || (valueText == option)>
            <label class="${properties.kcInputClassRadioLabel!}">
              <input
                type="${inputType}"
                name="${fieldName}"
                value="${option}"
                <#if checked>checked</#if>
                <#if attribute.readOnly!false>disabled</#if>
              />
              <#if attribute.annotations.inputOptionLabels??>
                ${advancedMsg(attribute.annotations.inputOptionLabels[option]!option)}
              <#elseif attribute.annotations.inputOptionLabelsI18nPrefix??>
                ${msg(attribute.annotations.inputOptionLabelsI18nPrefix + '.' + option)}
              <#else>
                ${option}
              </#if>
            </label>
          </#list>
        </div>
        <#if hasError>
          <span class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
            ${errorMsg?no_esc}
          </span>
        </#if>
      <#if fieldName=="email">
        <@input.kw
        autocomplete=(attribute.autocomplete)!''
        invalid=hasError
        label=(labelText + (attribute.required?string(' *','')))
        message=errorMsg
        name=fieldName
        type=resolvedType

        value=valueText
        />
      </#if>
      <#else>
      <#-- Default: your input atom for single-value fields -->
        <#if attribute.readOnly!false>
          <div class="${properties.kcInputWrapperClass!}">
            <input
              id="${fieldName}"
              name="${fieldName}"
              type="${resolvedType}"
              value="${valueText}"
              <#if attribute.autocomplete??>autocomplete="${attribute.autocomplete}"</#if>
              disabled
              aria-invalid="<#if hasError>true</#if>"
            />
          </div>
          <#if hasError>
            <span class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
              ${errorMsg?no_esc}
            </span>
          </#if>
        <#else>
          <@input.kw
          autocomplete=(attribute.autocomplete)!''
          invalid=hasError
          label=(labelText + (attribute.required?string(' *','')))
          message=errorMsg
          name=fieldName
          type=resolvedType
          value=valueText
          />
        </#if>
      </#if>

      <#-- Optional helper text AFTER the field -->
      <#if attribute.annotations.inputHelperTextAfter??>
        <p class="${properties.kcLabelClass!}">
          ${kcSanitize(advancedMsg(attribute.annotations.inputHelperTextAfter))?no_esc}
        </p>
      </#if>

      <#nested "afterField" attribute>
    </div>
  </#list>

<#-- If profile requests extra scripts via annotations, include them -->
  <#if profile.html5DataAnnotations??>
    <#list profile.html5DataAnnotations?keys as key>
      <script type="module" src="${url.resourcesPath}/js/${key}.js"></script>
    </#list>
  </#if>
</#macro>
