import Combine
import Dispatch

final class TestScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler
where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {

    var now: SchedulerTimeType
    var minimumTolerance: SchedulerTimeType.Stride = 0

    private var scheduledActions: [(action: () -> Void, date: SchedulerTimeType)] = []

    init(now: SchedulerTimeType) {
        self.now = now
    }

    func advance(by stride: SchedulerTimeType.Stride = .zero) {
        self.now = self.now.advanced(by: stride)

        scheduledActions.forEach { action, date in
            if date <= self.now {
                action()
            }
        }
        scheduledActions.removeAll(where: { $0.date <= self.now })
    }

    func schedule(
        options: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        scheduledActions.append((action, self.now))
    }

    func schedule(
        after date: SchedulerTimeType,
        tolerance: SchedulerTimeType.Stride,
        options: SchedulerOptions?,
        _ action: @escaping () -> Void)
    {
        self.scheduledActions.append((action, date))
    }

    func schedule(
        after date: SchedulerTimeType,
        interval: SchedulerTimeType.Stride,
        tolerance: SchedulerTimeType.Stride,
        options: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) -> Cancellable {
        return AnyCancellable {}
    }
}

extension DispatchQueue {
    static var testScheduler: TestScheduler<SchedulerTimeType, SchedulerOptions> {
        return TestScheduler(now: .init(.init(uptimeNanoseconds: 1)))
    }
}
