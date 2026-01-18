import type { Plugin } from "@opencode-ai/plugin"

export const BonzaiRemoveUnsupportedParams: Plugin = async () => {
  return {
    async "chat.params"({ provider, model }, output) {
      const isBonzai = provider?.id?.includes("bonzai")
      const modelId = String(model?.id || "")

      if (!isBonzai) return

      // Sanitize Bonzai chat params only; model/behavior set in opencode.json
      const activeModel = String(output.model || modelId)


      // Claude 4.5 families sometimes require extended-thinking controls; disable by default
      if (/claude-4-5|claude-opus-4-5|claude-4-5-haiku/.test(activeModel)) {
        output.options["thinking"] = undefined
        output.options["reasoning"] = undefined
        output.options["reasoningEffort"] = undefined
      }

      // OpenAI o* reasoning models typically ignore/forbid temperature
      if (/\bo\d\b/.test(activeModel) || /\bo[34]-mini\b/.test(activeModel)) {
        output.options["temperature"] = undefined
      }

      // Conservative defaults for tool choice if the model supports tools
      if (output.options && (output.options as any)["tools"]) {
        ;(output.options as any)["tool_choice"] = (output.options as any)["tool_choice"] || "auto"
      }
    }
  }
}
