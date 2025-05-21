#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QQmlContext>

#include "TelemetryReceiver.h"
#include "TelemetryModel.h"  // ⬅ Make sure this is created and included

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QFontDatabase::addApplicationFont(":/fonts/assets/Poppins-Regular.ttf");
    QFont appFont("Poppins");
    app.setFont(appFont);

    // Create telemetry components
    TelemetryReceiver telemetryReceiver;
    TelemetryModel telemetryModel;

    // Connect receiver to the model
    telemetryReceiver.setModel(&telemetryModel);

    QQmlApplicationEngine engine;

    // Expose both objects to QML
    engine.rootContext()->setContextProperty("telemetryReceiver", &telemetryReceiver);
    engine.rootContext()->setContextProperty("telemetryModel", &telemetryModel);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("swarm_gcs", "Main");

    return app.exec();
}
