//
//  TaskWidget.swift
//  TaskWidget
//
//  Created by jusong on 2023/08/24.
//

import WidgetKit
import SwiftUI

// 위젯을 업데이트 할 시기를 WidgetKit에 알리는 역할
struct Provider: TimelineProvider {
    // 데이터를 불러오기 전(getSnapshot)에 보여줄 placeholder
    func placeholder(in context: Context) -> TaskEntry {
        /// PlaceHolder View Custom
        TaskEntry(lastThreeTask: Array(TaskDataModel.shared.tasks.prefix(3)))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let entry = TaskEntry(lastThreeTask: Array(TaskDataModel.shared.tasks.prefix(3)))
        completion(entry)
    }
    
    // 위젯을 언제 업데이트 시킬것인지 구현하는 부분
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let latestTasks = Array(TaskDataModel.shared.tasks.prefix(3))
        let timeline = Timeline(entries: [TaskEntry(lastThreeTask: latestTasks)], policy: .atEnd)
        /// 마지막 data가 끝난 후 타임라인
        completion(timeline)
    }
}

struct TaskEntry: TimelineEntry {
    let date: Date = .now
    var lastThreeTask: [TaskModel]
}

struct TaskWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Task's")
                .fontWeight(.semibold)
                .padding(.bottom,10)
            
            VStack(alignment: .leading, spacing: 6) {
                if entry.lastThreeTask.isEmpty {
                    Text("No Task's Found")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(entry.lastThreeTask) { task in
                        HStack(spacing: 6) {
                            Button(intent: ToggleStateIntent(id: task.id)) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(.plain)
                            
                            VStack(alignment: .leading, spacing: 4, content: {
                                Text(task.taskTitle)
                                    .textScale(.secondary)
                                    .lineLimit(1)
                                    .strikethrough(task.isCompleted, pattern: .solid, color: .primary)
                                
                                Divider() // ??
                            })
                        }
                        
                        if task.id != entry.lastThreeTask.last?.id{
                            Spacer(minLength: 0)
                        }
                    }
                }
            }
        }
    }
}

struct TaskWidget: Widget {
    let kind: String = "TaskWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TaskWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TaskWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Task Widget")
        .description("This is an example interactive widget.")
    }
}

#Preview(as: .systemSmall) {
    TaskWidget()
} timeline: {
    TaskEntry(lastThreeTask: TaskDataModel.shared.tasks)
}
