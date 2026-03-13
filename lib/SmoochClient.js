"use strict";

import { NativeModules } from "react-native";

export class SmoochError extends Error {
  constructor(message) {
    super(message);
    this.name = "SmoochError";
  }
}

const LINKING_ERROR =
  `The package 'react-native-smooch' doesn't seem to be linked. Make sure: \n\n${Platform.select(
    { ios: "- You have run 'pod install'\n", default: "" },
  )}- You rebuilt the app after installing the package\n` +
  `- You are not using Expo Go\n`;

const Smooch = NativeModules.RCTSmooch
  ? NativeModules.RCTSmooch
  : new Proxy(
      {},
      {
        get() {
          throw new SmoochError(LINKING_ERROR);
        },
      },
    );

export function initialize(integrationId) {
  if (typeof integrationId !== "string") {
    return Promise.reject(new SmoochError("invalid integration ID"));
  }
  return Smooch.initialize(integrationId);
}

export function show() {
  return Smooch.show();
}

export function close() {
  return Smooch.close();
}

export function destroy() {
  return Smooch.destroy();
}

export default {
  initialize,
  show,
  close,
  destroy,
};
