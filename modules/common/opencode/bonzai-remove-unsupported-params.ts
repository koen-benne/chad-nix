import type { Plugin } from "@opencode-ai/plugin"

export const BonzaiRemoveUnsupportedParams: Plugin = async () => {
  return {
    async "chat.params"({ provider, model }, output) {
      // if (provider.id.includes("bonzai") && model.id.includes("gpt-5")) {
      //   output.options["textVerbosity"] = undefined
      // }
    }
  }
}
