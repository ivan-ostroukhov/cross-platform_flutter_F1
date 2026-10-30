import '../../domain/constructor_model.dart';
import '../dto/constructor_dto.dart';

extension ConstructorStandingDtoMapper on ConstructorStandingDto {
  ConstructorModel toDomain() {
    return ConstructorModel(
      id: constructor.constructorId,
      name: constructor.name,
      nationality: constructor.nationality,
      position: int.tryParse(position) ?? 0,
      points: int.tryParse(points) ?? 0,
      wins: int.tryParse(wins) ?? 0,
    );
  }
}

extension ConstructorStandingDtoListMapper on List<ConstructorStandingDto> {
  List<ConstructorModel> toDomainList() {
    return map((e) => e.toDomain()).toList();
  }
}