#include "TelemetryReceiver.h"
#include "TelemetryModel.h"  // Include the model header
#include <QJsonDocument>
#include <QJsonParseError>
#include <QDebug>

TelemetryReceiver::TelemetryReceiver(QObject *parent) : QObject(parent) {
    udpSocket = new QUdpSocket(this);
    udpSocket->bind(QHostAddress::AnyIPv4, 5005);
    connect(udpSocket, &QUdpSocket::readyRead, this, &TelemetryReceiver::readPendingDatagrams);
}

void TelemetryReceiver::setModel(TelemetryModel *model) {
    this->model = model;
}

void TelemetryReceiver::readPendingDatagrams() {
    while (udpSocket->hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(udpSocket->pendingDatagramSize());
        udpSocket->readDatagram(datagram.data(), datagram.size());

        QJsonParseError err;
        QJsonDocument doc = QJsonDocument::fromJson(datagram, &err);
        if (err.error == QJsonParseError::NoError && doc.isObject()) {
            QJsonObject obj = doc.object();

            // Store in model (if set)
            if (model) {
                model->addTelemetry(obj);
            }

            // Still emit for QML if needed
            emit telemetryReceived(obj);
        } else {
            qWarning() << "Invalid JSON:" << datagram;
        }
    }
}
