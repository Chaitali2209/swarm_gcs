#include "TelemetryModel.h"

TelemetryModel::TelemetryModel(QObject *parent)
    : QAbstractListModel(parent) {}

int TelemetryModel::rowCount(const QModelIndex &) const {
    return m_entries.size();
}

QVariant TelemetryModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_entries.size())
        return {};

    const TelemetryData &entry = m_entries[index.row()];
    switch (role) {
    case TimestampRole: return entry.timestamp;
    case ObjectRole: return entry.object;
    case TargetLatRole: return entry.targetLat;
    case TargetLonRole: return entry.targetLon;
    case DroneLatRole: return entry.droneLat;
    case DroneLonRole: return entry.droneLon;
    case AltitudeRole: return entry.altitude;
    case YawRole: return entry.yaw;
    default: return {};
    }
}

QHash<int, QByteArray> TelemetryModel::roleNames() const {
    return {
        {TimestampRole, "timestamp"},
        {ObjectRole, "object"},
        {TargetLatRole, "targetLat"},
        {TargetLonRole, "targetLon"},
        {DroneLatRole, "droneLat"},
        {DroneLonRole, "droneLon"},
        {AltitudeRole, "altitude"},
        {YawRole, "yaw"}
    };
}

void TelemetryModel::addTelemetry(const QJsonObject &data) {
    beginInsertRows(QModelIndex(), m_entries.size(), m_entries.size());
    m_entries.append({
        data["timestamp"].toString(),
        data["object"].toString(),
        data["target_lat"].toDouble(),
        data["target_lon"].toDouble(),
        data["drone_lat"].toDouble(),
        data["drone_lon"].toDouble(),
        data["altitude"].toDouble(),
        data["yaw"].toDouble()
    });
    endInsertRows();
}
