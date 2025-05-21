#pragma once

#include <QAbstractListModel>
#include <QJsonObject>

struct TelemetryData {
    QString timestamp;
    QString object;
    double targetLat;
    double targetLon;
    double droneLat;
    double droneLon;
    double altitude;
    double yaw;
};

class TelemetryModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum Roles {
        TimestampRole = Qt::UserRole + 1,
        ObjectRole,
        TargetLatRole,
        TargetLonRole,
        DroneLatRole,
        DroneLonRole,
        AltitudeRole,
        YawRole
    };

    explicit TelemetryModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void addTelemetry(const QJsonObject &data);

private:
    QList<TelemetryData> m_entries;
};
