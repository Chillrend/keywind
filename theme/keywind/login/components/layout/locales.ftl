<#import "../icon/chevron-down.ftl" as iconChevronDown>
<#import "../link/secondary.ftl" as linkSecondary>

<#macro kw>
  <div class="relative" x-data="{open: false}">
    <@linkSecondary.kw component="button" type="button" @click="open = true">
      <div class="flex items-center">
          <#if locale.current == "id">
            <span class="text-sm">Indonesia</span>
          <#else >
            <span class="text-sm">${locale.current}</span>
          </#if>
        <@iconChevronDown.kw />
      </div>
    </@linkSecondary.kw>
    <div
      class="absolute bg-white bottom-0 -left-4 max-h-80 mb-6 overflow-y-scroll rounded-lg shadow-lg"
      x-cloak
      x-show="open"
      @click.away="open = false"
    >
      <#list locale.supported as locales>
        <#if locale.current != locales.label>
          <div class="px-4 py-2">
            <@linkSecondary.kw href=locales.url>
              <#if locales.label == "id">
                <span class="text-sm">Indonesia</span>
              <#else >
                <span class="text-sm">${locales.label}</span>
              </#if>
            </@linkSecondary.kw>
          </div>
        </#if>
      </#list>
    </div>
  </div>
</#macro>
