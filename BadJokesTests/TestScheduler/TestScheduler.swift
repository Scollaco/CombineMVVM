import Combine
import Dispatch

final class TestScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler
where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {

    var now: SchedulerTimeType
    var minimumTolerance: SchedulerTimeType.Stride = 0
    private var lastId = 0
    private var scheduledActions: [(id: Int, action: () -> Void, date: SchedulerTimeType)] = []

    init(now: SchedulerTimeType) {
        self.now = now
    }

    private func nextId() -> Int {
        lastId += 1
        return lastId
    }

    func advance(by stride: SchedulerTimeType.Stride = .zero) {

        scheduledActions.sort { lhs, rhs in
            (lhs.date, lhs.id) < (rhs.date, rhs.id)
        }

        guard let nextDate = scheduledActions.first?.date,
              now.advanced(by: stride) >= nextDate else {
            now = now.advanced(by: stride)
            return
        }
        let nextStride = stride - now.distance(to: nextDate)

        now = nextDate

        while let (_, action, date) = scheduledActions.first, date == nextDate {
            scheduledActions.removeFirst()
            action()
        }
        advance(by: nextStride)
        scheduledActions.removeAll(where: { $0.date <= self.now })
    }

    func schedule(
        options: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        scheduledActions.append((nextId(), action, self.now))
    }

    func schedule(
        after date: SchedulerTimeType,
        tolerance: SchedulerTimeType.Stride,
        options: SchedulerOptions?,
        _ action: @escaping () -> Void)
    {
        self.scheduledActions.append((nextId(), action, date))
    }

    func schedule(
        after date: SchedulerTimeType,
        interval: SchedulerTimeType.Stride,
        tolerance: SchedulerTimeType.Stride,
        options: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) -> Cancellable {

        let id = nextId()
        func scheduleAction(for date: SchedulerTimeType) -> () -> Void {
            return { [weak self] in
                let nextDate = date.advanced(by: interval)
                self?.scheduledActions.append((id, scheduleAction(for: nextDate), nextDate))
                action()
            }
        }

        scheduledActions.append((id, scheduleAction(for: date), date))
        return AnyCancellable {
            self.scheduledActions.removeAll(where: { $0.id == id })
        }
    }
}

extension DispatchQueue {
    static var testScheduler: TestScheduler<SchedulerTimeType, SchedulerOptions> {
        return TestScheduler(now: .init(.init(uptimeNanoseconds: 1)))
    }
}
