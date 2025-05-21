#pragma once

#include <QObject>
#include <QUdpSocket>
#include <QJsonObject>

class TelemetryModel;  // Forward declaration

class TelemetryReceiver : public QObject {
    Q_OBJECT
public:
    explicit TelemetryReceiver(QObject *parent = nullptr);

    // Connects the receiver to the model
    void setModel(TelemetryModel *model);

signals:
    void telemetryReceived(QJsonObject data);  // Emits JSON to QML if needed

private slots:
    void readPendingDatagrams();

private:
    QUdpSocket *udpSocket;
    TelemetryModel *model = nullptr;  // Pointer to model for storing logs
};
