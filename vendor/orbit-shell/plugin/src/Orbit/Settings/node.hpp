#pragma once

#include <qjsonvalue.h>
#include <qobject.h>

#include "changebatcher.hpp"
#include "common.hpp"
#include "quarantine.hpp"
#include "schema.hpp"

namespace orbit::settings {

class Node : public QObject {
    Q_OBJECT

public:
    
    explicit Node(Node* fallback, QObject* parent = nullptr, bool globalOnly = false);

    [[nodiscard]] QString key() const; 
    [[nodiscard]] QString path() const;
    [[nodiscard]] virtual QString pathFor(const QString& key) const;
    [[nodiscard]] static QString elementPath(const QString& path, const QString& index);
    [[nodiscard]] Node* parentNode() const;
    [[nodiscard]] Node* rootNode() const;
    [[nodiscard]] Node* fallbackNode() const;
    void detachFallback(); 

    [[nodiscard]] Q_INVOKABLE bool isGlobalOnly() const;
    [[nodiscard]] bool isOverride(const QString& key) const;
    [[nodiscard]] const QSet<QString>& overrides() const;
    [[nodiscard]] bool hasContent() const; 

    [[nodiscard]] virtual const Schema& schema() const = 0;

    [[nodiscard]] virtual QVariant value(const QString& key) const;
    virtual bool setValue(const QString& key, const QVariant& value); 
    virtual void resetToDefaults(); 

    [[nodiscard]] virtual QJsonValue toJson(bool sparse = true) const = 0;
    
    virtual bool syncJson(const QJsonValue& json, QList<Diagnostic>& diagnostics) = 0;
    [[nodiscard]] const Quarantine* quarantine() const;

signals:
    void optionChanged(const QString& key);

protected:
    
    std::unique_ptr<Quarantine> m_quarantine;

    
    bool forwardGlobalWrite(const QString& key, const QVariant& value);
    
    virtual bool recordWrite(const QString& key, bool changed);

    [[nodiscard]] bool removeQuarantined(const QString& key);
    [[nodiscard]] ChangeBatcher* batcher() const;

    [[nodiscard]] virtual QString keyOf(const Node* child) const;

    template <typename C, typename T>
    [[nodiscard]] T fallbackValue(T C::* member, std::type_identity_t<T> defaultValue) const;

private:
    QSet<QString> m_overrides; 
    Node* const m_rootNode;
    Node* m_fallbackNode;    
    const bool m_globalOnly; 

    
    WriteOrigin m_writeOrigin;
    ChangeBatcher* const m_batcher;

    void onFallbackNotify(const QString& key);

    friend class WriteScope;
};

template <typename C, typename T> T Node::fallbackValue(T C::* member, std::type_identity_t<T> defaultValue) const {
    const auto* fallback = static_cast<const C*>(m_fallbackNode);
    return fallback ? fallback->*member : defaultValue;
}

} 
