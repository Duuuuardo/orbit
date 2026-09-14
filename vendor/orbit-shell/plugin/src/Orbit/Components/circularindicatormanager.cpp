#include "circularindicatormanager.hpp"

#include <qeasingcurve.h>
#include <qpoint.h>

namespace {

namespace advance {

constexpr qint32 k_totalCycles = 4;
constexpr qint32 k_totalDurationInMs = 5400;
constexpr qint32 k_durationToExpandInMs = 667;
constexpr qint32 k_durationToCollapseInMs = 667;
constexpr qint32 k_durationToCompleteEndInMs = 333;
constexpr qint32 k_tailDegreesOffset = -20;
constexpr qint32 k_extraDegreesPerCycle = 250;
constexpr qint32 k_constantRotationDegrees = 1520;

constexpr std::array<qint32, k_totalCycles> k_delayToExpandInMs = { 0, 1350, 2700, 4050 };
constexpr std::array<qint32, k_totalCycles> k_delayToCollapseInMs = { 667, 2017, 3367, 4717 };

} 

namespace retreat {

constexpr qint32 k_totalDurationInMs = 6000;
constexpr qint32 k_durationSpinInMs = 500;
constexpr qint32 k_durationGrowActiveInMs = 3000;
constexpr qint32 k_durationShrinkActiveInMs = 3000;
constexpr std::array k_delaySpinsInMs = { 0, 1500, 3000, 4500 };
constexpr qint32 k_delayGrowActiveInMs = 0;
constexpr qint32 k_delayShrinkActiveInMs = 3000;
constexpr qint32 k_durationToCompleteEndInMs = 500;




constexpr qint32 k_constantRotationDegrees = 1080;


constexpr qint32 k_spinRotationDegrees = 90;
constexpr std::array<qreal, 2> k_endFractionRange = { 0.10, 0.87 };

} 

inline qreal getFractionInRange(qreal playtime, qreal start, qreal duration) {
    const auto fraction = (playtime - start) / duration;
    return std::clamp(fraction, 0.0, 1.0);
}

} 

namespace orbit::components {

CircularIndicatorManager::CircularIndicatorManager(QObject* parent)
    : QObject(parent)
    , m_type(IndeterminateAnimationType::Advance)
    , m_curve(QEasingCurve(QEasingCurve::BezierSpline))
    , m_progress(0)
    , m_startFraction(0)
    , m_endFraction(0)
    , m_rotation(0)
    , m_completeEndProgress(0) {
    
    m_curve.addCubicBezierSegment({ 0.4, 0.0 }, { 0.2, 1.0 }, { 1.0, 1.0 });
}

qreal CircularIndicatorManager::startFraction() const {
    return m_startFraction;
}

qreal CircularIndicatorManager::endFraction() const {
    return m_endFraction;
}

qreal CircularIndicatorManager::rotation() const {
    return m_rotation;
}

qreal CircularIndicatorManager::progress() const {
    return m_progress;
}

void CircularIndicatorManager::setProgress(qreal progress) {
    update(progress);
}

qreal CircularIndicatorManager::duration() const {
    if (m_type == IndeterminateAnimationType::Advance) {
        return advance::k_totalDurationInMs;
    }
    return retreat::k_totalDurationInMs;
}

qreal CircularIndicatorManager::completeEndDuration() const {
    if (m_type == IndeterminateAnimationType::Advance) {
        return advance::k_durationToCompleteEndInMs;
    }
    return retreat::k_durationToCompleteEndInMs;
}

CircularIndicatorManager::IndeterminateAnimationType CircularIndicatorManager::indeterminateAnimationType() const {
    return m_type;
}

void CircularIndicatorManager::setIndeterminateAnimationType(IndeterminateAnimationType t) {
    if (m_type != t) {
        m_type = t;
        emit indeterminateAnimationTypeChanged();
    }
}

qreal CircularIndicatorManager::completeEndProgress() const {
    return m_completeEndProgress;
}

void CircularIndicatorManager::setCompleteEndProgress(qreal progress) {
    if (qFuzzyCompare(m_completeEndProgress + 1.0, progress + 1.0)) {
        return;
    }

    m_completeEndProgress = progress;
    emit completeEndProgressChanged();

    update(m_progress);
}

void CircularIndicatorManager::update(qreal progress) {
    if (qFuzzyCompare(m_progress + 1.0, progress + 1.0)) {
        return;
    }

    if (m_type == IndeterminateAnimationType::Advance) {
        updateAdvance(progress);
    } else {
        updateRetreat(progress);
    }

    m_progress = progress;
    emit progressChanged();
}

void CircularIndicatorManager::updateRetreat(qreal progress) {
    using namespace retreat;
    const auto playtime = progress * k_totalDurationInMs;

    
    const qreal constantRotation = k_constantRotationDegrees * progress;
    
    qreal spinRotation = 0;
    for (const int spinDelay : k_delaySpinsInMs) {
        spinRotation += m_curve.valueForProgress(getFractionInRange(playtime, spinDelay, k_durationSpinInMs)) *
                        k_spinRotationDegrees;
    }
    const auto oldRotation = m_rotation;
    m_rotation = constantRotation + spinRotation;
    if (!qFuzzyCompare(m_rotation + 1.0, oldRotation + 1.0))
        emit rotationChanged();

    
    qreal fraction =
        m_curve.valueForProgress(getFractionInRange(playtime, k_delayGrowActiveInMs, k_durationGrowActiveInMs));
    fraction -=
        m_curve.valueForProgress(getFractionInRange(playtime, k_delayShrinkActiveInMs, k_durationShrinkActiveInMs));

    if (!qFuzzyIsNull(m_startFraction)) {
        m_startFraction = 0.0;
        emit startFractionChanged();
    }
    const auto oldEndFrac = m_endFraction;
    m_endFraction = std::lerp(k_endFractionRange[0], k_endFractionRange[1], fraction);

    
    if (m_completeEndProgress > 0) {
        m_endFraction *= 1 - m_completeEndProgress;
    }

    if (!qFuzzyCompare(m_endFraction + 1.0, oldEndFrac + 1.0)) {
        emit endFractionChanged();
    }
}

void CircularIndicatorManager::updateAdvance(qreal progress) {
    using namespace advance;
    const auto playtime = progress * k_totalDurationInMs;
    const auto oldStart = m_startFraction;
    const auto oldEnd = m_endFraction;

    
    m_startFraction = k_constantRotationDegrees * progress + k_tailDegreesOffset;
    m_endFraction = k_constantRotationDegrees * progress;

    
    for (size_t cycleIndex = 0; cycleIndex < k_totalCycles; ++cycleIndex) {
        
        qreal fraction = getFractionInRange(playtime, k_delayToExpandInMs[cycleIndex], k_durationToExpandInMs);
        m_endFraction += m_curve.valueForProgress(fraction) * k_extraDegreesPerCycle;

        
        fraction = getFractionInRange(playtime, k_delayToCollapseInMs[cycleIndex], k_durationToCollapseInMs);
        m_startFraction += m_curve.valueForProgress(fraction) * k_extraDegreesPerCycle;
    }

    
    m_startFraction += (m_endFraction - m_startFraction) * m_completeEndProgress;

    m_startFraction /= 360.0;
    m_endFraction /= 360.0;

    if (!qFuzzyCompare(m_startFraction + 1.0, oldStart + 1.0))
        emit startFractionChanged();
    if (!qFuzzyCompare(m_endFraction + 1.0, oldEnd + 1.0))
        emit endFractionChanged();
}

} 
