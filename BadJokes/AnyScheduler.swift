import Combine

typealias AnySchedulerOf<S: Scheduler> = AnyScheduler<S.SchedulerTimeType, S.SchedulerOptions>

struct AnyScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler
where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {

    private let _now: () -> SchedulerTimeType
    var now: SchedulerTimeType {
        _now()
    }

    private let _minimumTolerance: () -> SchedulerTimeType.Stride
    var minimumTolerance: SchedulerTimeType.Stride {
        _minimumTolerance()
    }

    private let _schedule: (SchedulerOptions?, @escaping () -> Void) -> Void
    private let _scheduleAfterDelay: (
        SchedulerTimeType, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void
    ) -> Void
    private let _schedulerWithInterval: (
        SchedulerTimeType, SchedulerTimeType.Stride, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void
    ) -> Cancellable

    init<S: Scheduler>(
        _ scheduler: S
    )
    where S.SchedulerTimeType == SchedulerTimeType, S.SchedulerOptions == SchedulerOptions {
        _now = { scheduler.now }
        _minimumTolerance = { scheduler.minimumTolerance }
        _schedule = {  scheduler.schedule(options: $0, $1) }
        _scheduleAfterDelay = { scheduler.schedule(after: $0, tolerance: $1, options: $2, $3) }
        _schedulerWithInterval = { scheduler.schedule(after: $0, interval: $1, tolerance: $2, options: $3, $4) }
    }

    func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _schedule(options, action)
    }

    func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _scheduleAfterDelay(date, tolerance, options, action)
    }

    func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
        _schedulerWithInterval(date, interval, tolerance, options, action)
    }
}

extension Scheduler {
    func eraseToAnyScheduler() -> AnyScheduler<SchedulerTimeType, SchedulerOptions> {
        AnyScheduler(self)
    }
}
