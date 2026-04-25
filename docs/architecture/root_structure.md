├───assets
    ├───data
    │    ├───levels.json
    │       
    ├───fonts
    |       Exo2-Bold.ttf
    |       Exo2-Regular.ttf
    |       Orbitron-Bold.ttf
    |       Orbitron-Regular.ttf
    │          
    └───images
            robot.png

          
├───lib
│   │   firebase_options.dart
│   │   main.dart
│   │   
│   ├───app
│   │       app.dart
│   │       router.dart
│   │       
│   ├───core
│   │   ├───config
│   │   │       firebase_options.dart
│   │   │       
│   │   └───theme
│   │           app_colors.dart
│   │           app_text_styles.dart
│   │           app_theme.dart
│   │           
│   ├───features
│   │   ├───auth
│   │   │   ├───application
│   │   │   │       auth_state_provider.dart
│   │   │   │       
│   │   │   ├───data
│   │   │   │   │   auth_repository.dart
│   │   │   │   │   
│   │   │   │   └───services
│   │   │   │           auth_service.dart
│   │   │   │           auth_services.dart
│   │   │   │           firestore_services.dart
│   │   │   │           
│   │   │   └───presentation
│   │   │       ├───pages
│   │   │       │       loading_screen.dart
│   │   │       │       login_screen.dart
│   │   │       │       signup_screen.dart
│   │   │       │       
│   │   │       ├───screens
│   │   │       │       login_screen.dart
│   │   │       │       
│   │   │       └───widgets
│   │   │               auth_logo.dart
│   │   │               auth_primary_button.dart
│   │   │               auth_shell.dart
│   │   │               auth_text_field.dart
│   │   │               
│   │   ├───dashboard
│   │   │   └───presentation
│   │   │       ├───pages
│   │   │       │       dashboard_screen.dart
│   │   │       │       
│   │   │       └───widgets
│   │   │               current_mission_card.dart
│   │   │               daily_challenge_card.dart
│   │   │               dashboard_header.dart
│   │   │               journey_map_card.dart
│   │   │               progress_card.dart
│   │   │               
│   │   ├───gameplay
│   │   │   ├───application
│   │   │   │       command_sequence_provider.dart
│   │   │   │       current_level_provider.dart
│   │   │   │       execution_engine.dart
│   │   │   │       execution_engine_provider.dart
│   │   │   │       execution_state_notifier.dart
│   │   │   │       firestore_provider.dart
│   │   │   │       gameplay_providers.dart
│   │   │   │       levels_provider.dart
│   │   │   │       
│   │   │   ├───data
│   │   │   │       levels_firestore_service.dart
│   │   │   │       
│   │   │   ├───domain
│   │   │   │   └───models
│   │   │   │           command_type.dart
│   │   │   │           coordinate.dart
│   │   │   │           direction.dart
│   │   │   │           execution_state.dart
│   │   │   │           execution_status.dart
│   │   │   │           level_state.dart
│   │   │   │           
│   │   │   └───presentation
│   │   │       ├───pages
│   │   │       │       gameplay_loader_screen.dart
│   │   │       │       gameplay_screen.dart
│   │   │       │       
│   │   │       └───widgets
│   │   │               command_block.dart
│   │   │               command_palette.dart
│   │   │               game_action_bar.dart
│   │   │               game_grid.dart
│   │   │               grid_cell.dart
│   │   │               sequence_panel.dart
│   │   │               
│   │   └───onboarding
│   │       ├───application
│   │       │       onboarding_provider.dart
│   │       │       
│   │       └───presentation
│   │           └───pages
│   │                   intro_one_screen.dart
│   │                   intro_three_screen.dart
│   │                   intro_two_screen.dart
│   │                   
│   └───shared
│       └───widgets
│               neon_card.dart
│               xp_badge.dart
│               
└───test
    │   widget_test.dart
    │   
    └───features
        └───gameplay
            ├───application
            │       execution_engine_test.dart
            │       
            ├───domain
            │   └───models
            │           coordinate_test.dart
            │           
            └───presentation
                    gameplay_drag_drop_test.dart
                    gameplay_run_test.dart



