import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/helpers/request_helper.dart';
import 'package:zakir/src/models/entities/check_version_model.dart';
import 'package:zakir/src/models/enums.dart';

class UserService {
 
  Future<CheckVersionModel> getVersionInfo(BuildContext context) async {
    final response = await RequestHelper.requestAsync(
        context, RequestType.Get, ApiServiceUrl.checkVersion);

    if (response == null || response.isEmpty) return null;
    return CheckVersionModel.fromJson(json.decode(response)["data"]);
  }
}