# Simplified Swapify Core Architecture

Here is the simplified UML Class Diagram tailored for a presentation slide. It focuses exclusively on the core domain entities and their primary relationships, omitting DTOs, controllers, services, and boilerplate fields (like `id`, `createdAt`) to keep it clean and highly readable.

```mermaid
classDiagram
    direction LR

    class User {
        +String name
        +String email
        +Boolean isPremium
        +Number swapCount
        +String status
    }

    class Skill {
        +String name
        +String category
    }

    class UserSkill {
        +Number proficiency
    }

    class UserLearningGoal {
        +Number priority
    }

    class SwapRequest {
        +String status
        +Number rating
        +String message
    }

    class Message {
        +String content
        +Boolean isRead
    }

    class Notification {
        +String type
        +String title
        +Boolean isRead
    }

    class Certificate {
        +String title
        +String fileUrl
    }

    class Subscription {
        +String plan
        +String status
        +Date expiresAt
    }

    %% Core Relationships
    User "1" --> "*" UserSkill : has
    User "1" --> "*" UserLearningGoal : has
    User "1" --> "*" Certificate : uploads
    User "1" --> "*" Subscription : subscribes
    User "1" --> "*" Notification : receives

    UserSkill "*" --> "1" Skill : refers to
    UserLearningGoal "*" --> "1" Skill : targets
    Certificate "*" --> "1" Skill : validates

    %% Swap Request Flow
    SwapRequest "*" --> "1" User : requester
    SwapRequest "*" --> "1" User : provider
    SwapRequest "*" --> "1" Skill : requesterSkill
    SwapRequest "*" --> "1" Skill : providerSkill

    %% Messaging
    Message "*" --> "1" SwapRequest : belongs to
    Message "*" --> "1" User : sender
```
