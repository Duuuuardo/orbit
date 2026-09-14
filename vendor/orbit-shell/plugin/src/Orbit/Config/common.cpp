#include "common.hpp"

#include <qstandardpaths.h>

namespace orbit::config {

using Qt::StringLiterals::operator""_s;

Q_LOGGING_CATEGORY(lcConfig, "orbit.config", QtInfoMsg)

QString configDir() {
    return QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) + u"/orbit"_s;
}

QString monitorConfigDir() {
    return configDir() + u"/monitors"_s;
}

} 
