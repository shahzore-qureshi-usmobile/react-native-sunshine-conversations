'use strict';

import { NativeModules } from 'react-native';

const { SmoochManager } = NativeModules;

module.exports = Object.assign({}, SmoochManager);
