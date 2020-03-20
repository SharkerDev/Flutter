import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:example/config/api.dart';
import 'package:example/stores/card_store/card_model_store.dart';
import 'package:example/stores/fault_store/fault_model_store.dart';
import 'package:example/stores/index.dart';
import 'package:example/stores/rating_details_store/rating_details_model_store.dart';
import 'package:example/stores/service_store/service_model_store.dart';
import 'package:example/stores/sub_service_store/sub_service_model_store.dart';
import 'package:example/stores/technicians_store/technician_model_store.dart';
import 'package:example/stores/unit_store/unit_model_store.dart';
import 'package:mobx/mobx.dart';

part 'request_model_store.g.dart';

class RequestModelStore = _RequestModelStore with _$RequestModelStore;

enum RequestState {
  unknown0,
  pending,
  declined,
  confirmed,
  unknown4,
  addedToWorkOrder,
  unknown6,
  unknown7,
  unknown8,
  completed,
}

final Map<RequestState, String> requestStateString = {
  RequestState.unknown0: 'unknown0',
  RequestState.pending: 'Pending',
  RequestState.declined: 'Declined',
  RequestState.confirmed: 'Confirmed',
  RequestState.unknown4: 'unknown4',
  RequestState.addedToWorkOrder: 'Added to work order',
  RequestState.unknown6: 'unknown6',
  RequestState.unknown7: 'unknown7',
  RequestState.unknown8: 'unknown8',
  RequestState.completed: 'Completed',
};

final confirmActionName = 'SETCONFIRMEDREQUESTSTATEACTION';
final declineActionName = 'SETDECLINEDREQUESTSTATEACTION';
final createWorkOrderName = 'CREATEWORKORDERREQUESTSTATEACTION';
final completeActionName = 'SETCOMPLETEDREQUESTSTATEACTION';

abstract class _RequestModelStore extends CardModelStore with Store {
  _RequestModelStore(Map<String, dynamic> data) : super(data);
  _RequestModelStore.plain() : super.plain();

  @observable
  SubServiceModelStore subservice;

  @observable
  FaultModelStore fault;

  @observable
  bool isCommonArea;

  @observable
  String description;

  @observable
  ObservableList workOrders;

  @observable
  bool isDeleted;

  @observable
  DateTime deletedOn;

  @observable
  String deletedBy;

  @observable
  RatingModelStore ratingDetails = RatingModelStore.plain();

  @computed
  TechnicianModelStore get technician => technicianStore.data.firstWhere(
      (technician) => technician.requests.contains(this),
      orElse: () => null);

  @override
  @action
  void serialize(Map<String, dynamic> data) {
    super.serialize(data);
    titleImage = images.isNotEmpty ? images.first : null;
    isCommonArea = data['isCommonArea'];
    description = data['description'];
    if (data['fault'] != null) fault = FaultModelStore(data['fault']);
    state = RequestState.values[data['state']];
    if (data['deletedOn'] != null)
      deletedOn = DateTime.parse(data['deletedOn']);
    if (data['ratingDetails'] != null) {
      ratingDetails = RatingModelStore(data['ratingDetails']);
      ratingDetails.requestId = id;
    }
    deletedBy = data['deletedBy'];
  }

  @action
  void setUnit(UnitModelStore unit) {
    this.unit = unit;
    this.service = null;
    this.subservice = null;
    this.fault = null;
  }

  @action
  void setService(ServiceModelStore service) {
    this.service = service;
    this.subservice = null;
    this.fault = null;
  }

  @action
  void setSubService(SubServiceModelStore subservice) {
    this.subservice = subservice;
    this.fault = null;
  }

  @action
  void setProblem(FaultModelStore fault) {
    this.fault = fault;
  }

  @action
  void setDescription(String description) {
    this.description = description;
  }

  @action
  Future<void> confirm() async {
    await api.post('/api/Requests/action', data: {
      'requestId': id,
      'action': confirmActionName,
    });
    this.state = RequestState.confirmed;
  }

  @action
  Future<void> decline() async {
    await api.post('/api/Requests/action', data: {
      'requestId': id,
      'action': declineActionName,
    });
    this.state = RequestState.declined;
  }

  @action
  Future<void> complete() async {
    await api.post('/api/Requests/action', data: {
      'requestId': id,
      'action': completeActionName,
      'rating': 0,
    });
    this.state = RequestState.completed;
  }

  @action
  Future<void> createWorkOrder() async {
    await api.post('/api/Requests/action', data: {
      'requestId': id,
      'action': createWorkOrderName,
    });
    this.state = RequestState.addedToWorkOrder;
  }

  @action
  void setCompliment(Compliment compliment) {
    if (compliment == this.ratingDetails.compliment)
      this.ratingDetails.compliment = null;
    else
      this.ratingDetails.compliment = compliment;
  }

  @action
  void setRating(int rating) => this.ratingDetails.rating = rating;

  @action
  void setRatingNotes(String notes) => this.ratingDetails.notes = notes;

  @action
  Future<void> sendRate() async {
    ratingDetails.loading = true;
    ratingDetails.requestId = id;
    final json = ratingDetails.toJson();
    await api.post(
      '/api/Requests/raterequest',
      data: json,
    );
    ratingDetails.loading = false;
  }

  @action
  Future<Response> send() async {
    loading = true;
    try {
      final encodedImages =
          images.map((imgFile) => base64.encode(imgFile)).toList();
      final response = await api.post('/api/Requests', data: {
        "serviceId": service.id,
        "subServiceId": subservice.id,
        "problemId": fault.id,
        "unitId": unit.id,
        "isCommonArea": true,
        "description": description,
        "photos": encodedImages,
        "priority": 1,
      });
      requestStore.loaded = false;
      requestStore.load(withLoadingIndicator: false);

      loading = false;
      return response;
    } catch (e) {
      loading = false;
      throw e;
    }
  }

  Map<String, dynamic> toJson() => {
        "unit": unit.toJson(),
        "isCommonArea": isCommonArea,
        "service": service.toJson(),
        "createDate": createdDate.toIso8601String(),
        "priority": priority,
        "fault": fault.toJson(),
        "serial": serial,
        "files": [],
        "isDeleted": isDeleted,
        "deletedOn": deletedOn?.toIso8601String(),
        "deletedBy": deletedBy,
        "state": state.index + 1,
        "submittedBy": submittedBy.toJson(),
        "id": id,
      };
}
