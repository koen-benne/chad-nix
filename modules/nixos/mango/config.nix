# Shared Mango configuration
{
  scripts ? null,
}: ''

  # More option see https://github.com/DreamMaoMao/mango/wiki/

  # Window effect
  blur=0
  blur_layer=0
  blur_optimized=1
  blur_params_num_passes = 2
  blur_params_radius = 5
  blur_params_noise = 0.02
  blur_params_brightness = 0.9
  blur_params_contrast = 0.9
  blur_params_saturation = 1.2

  shadows = 0
  layer_shadows = 0
  shadow_only_floating = 1
  shadows_size = 10
  shadows_blur = 15
  shadows_position_x = 0
  shadows_position_y = 0
  shadowscolor= 0x000000ff

  border_radius=6
  no_radius_when_single=0
  focused_opacity=1.0
  unfocused_opacity=1.0

  # Animation Configuration(support type:zoom,slide)
  # tag_animation_direction: 0-horizontal,1-vertical
  animations=1
  layer_animations=1
  animation_type_open=slide
  animation_type_close=slide
  animation_fade_in=1
  animation_fade_out=1
  tag_animation_direction=1
  zoom_initial_ratio=0.3
  zoom_end_ratio=0.8
  fadein_begin_opacity=0.5
  fadeout_begin_opacity=0.8
  animation_duration_move=500
  animation_duration_open=400
  animation_duration_tag=350
  animation_duration_close=800
  animation_duration_focus=0
  animation_curve_open=0.46,1.0,0.29,1
  animation_curve_move=0.46,1.0,0.29,1
  animation_curve_tag=0.46,1.0,0.29,1
  animation_curve_close=0.08,0.92,0,1
  animation_curve_focus=0.46,1.0,0.29,1

  # Scroller Layout Setting
  scroller_structs=20
  scroller_default_proportion=0.8
  scroller_focus_center=0
  scroller_prefer_center=0
  edge_scroller_pointer_focus=1
  scroller_default_proportion_single=1.0
  scroller_proportion_preset=0.5,0.8,1.0

  # Master-Stack Layout Setting
  new_is_master=1
  default_mfact=0.55
  default_nmaster=1
  smartgaps=0

  # Overview Setting
  hotarea_size=10
  enable_hotarea=1
  ov_tab_mode=0
  overviewgappi=5
  overviewgappo=30

  # Misc
  no_border_when_single=0
  axis_bind_apply_timeout=100
  focus_on_activate=1
  inhibit_regardless_of_visibility=0
  sloppyfocus=1
  warpcursor=1
  focus_cross_monitor=0
  focus_cross_tag=0
  enable_floating_snap=0
  snap_distance=30
  cursor_size=24
  drag_tile_to_tile=1

  # keyboard
  repeat_rate=25
  repeat_delay=600
  numlockon=0
  xkb_rules_layout=us

  # Trackpad
  # need relogin to make it apply
  disable_trackpad=0
  tap_to_click=1
  tap_and_drag=1
  drag_lock=1
  trackpad_natural_scrolling=0
  disable_while_typing=1
  left_handed=0
  middle_button_emulation=0
  swipe_min_threshold=1

  # mouse
  # need relogin to make it apply
  mouse_natural_scrolling=0

  # Appearance
  gappih=5
  gappiv=5
  gappoh=10
  gappov=10
  scratchpad_width_ratio=0.8
  scratchpad_height_ratio=0.9
  borderpx=4
  rootcolor=0x201b14ff
  bordercolor=0x444444ff
  focuscolor=0xc9b890ff
  maximizescreencolor=0x89aa61ff
  urgentcolor=0xad401fff
  scratchpadcolor=0x516c93ff
  globalcolor=0xb153a7ff
  overlaycolor=0x14a57cff

  # layout support:
  # tile,scroller,grid,deck,monocle,center_tile,vertical_tile,vertical_scroller
  tagrule=id:1,layout_name:tile
  tagrule=id:2,layout_name:tile
  tagrule=id:3,layout_name:tile
  tagrule=id:4,layout_name:tile
  tagrule=id:5,layout_name:tile
  tagrule=id:6,layout_name:tile
  tagrule=id:7,layout_name:tile
  tagrule=id:8,layout_name:tile
  tagrule=id:9,layout_name:tile

  # Key Bindings
  # key name refer to `xev` or `wev` command output,
  # mod keys name: super,ctrl,alt,shift,none

  # reload config
  bind=SUPER,r,reload_config

  # menu and terminal
  bind=SUPER,r,spawn,dms ipc spotlight toggle
  bind=SUPER,Return,spawn,footclient
  bind=SUPER,w,spawn,zen
  bind=SUPER,q,killclient,
  bind=SUPER+CTRL+SHIFT,c,quit
  bind=SUPER,e,spawn,nautilus
  bind=SUPER,v,togglefloating,
  bind=SUPER,f,togglefullscreen,
  bind=SUPER,p,spawn,1password --quick-access
  bind=SUPER,c,spawn,hyprpicker -a

  # DMS specific keybindings
  bind=SUPER,b,spawn,dms ipc call bar toggle index 0
  bind=SUPER+CTRL,n,spawn,dms ipc notifications toggle
  bind=SUPER+CTRL,v,spawn,dms ipc clipboard toggle
  bind=SUPER+CTRL,p,spawn,dms ipc notepad toggle
  bind=SUPER+SHIFT,s,spawn,dms ipc lock lock
  bind=SUPER,x,spawn,dms ipc powermenu toggle
  bind=SUPER,s,spawn,dms ipc dankdash media
  bind=SUPER,Comma,spawn,dms ipc settings toggle

  # Media and system keys
  bind=,XF86AudioMedia,spawn,playerctl play-pause
  bind=,XF86AudioPlay,spawn,playerctl play-pause
  bind=,XF86AudioPrev,spawn,playerctl previous
  bind=,XF86AudioNext,spawn,playerctl next
  bind=,XF86AudioRaiseVolume,spawn,dms ipc call audio increment 3
  bind=,XF86AudioLowerVolume,spawn,dms ipc call audio decrement 3
  bind=,XF86AudioMute,spawn,dms ipc call audio mute
  bind=,XF86AudioMicMute,spawn,dms ipc call audio micmute
  bind=,XF86MonBrightnessUp,spawn,dms ipc call brightness increment 5 ""
  bind=,XF86MonBrightnessDown,spawn,dms ipc call brightness decrement 5 ""

  # switch window focus
  bind=SUPER,Tab,toggleoverview,
  bind=SUPER,h,focusdir,left
  bind=SUPER,l,focusdir,right
  bind=SUPER,j,focusdir,down
  bind=SUPER,k,focusdir,up

  # swap window
  bind=SUPER+SHIFT,h,exchange_client,left
  bind=SUPER+SHIFT,l,exchange_client,right
  bind=SUPER+SHIFT,j,exchange_client,down
  bind=SUPER+SHIFT,k,exchange_client,up

  # switch window status
  bind=SUPER,g,toggleglobal,
  bind=SUPER,space,toggleoverview,
  bind=SUPER,backslash,togglefloating,
  bind=SUPER,a,togglemaximizescreen,
  bind=SUPER,f,togglefullscreen,
  bind=SUPER+SHIFT,f,togglefakefullscreen,
  bind=SUPER,i,minimized,
  bind=SUPER,o,toggleoverlay,
  bind=SUPER+SHIFT,I,restore_minimized
  bind=SUPER,z,toggle_scratchpad

  # scroller layout
  bind=SUPER,n,set_proportion,1.0
  bind=SUPER,minus,switch_proportion_preset,

  # switch layout
  bind=SUPER,m,switch_layout

  # tag switch
  bind=SUPER,u,viewtoleft,0
  bind=CTRL,u,viewtoleft_have_client,0
  bind=SUPER,i,viewtoright,0
  bind=CTRL,i,viewtoright_have_client,0
  bind=CTRL+SUPER,u,tagtoleft,0
  bind=CTRL+SUPER,i,tagtoright,0

  bind=SUPER,1,view,1,0
  bind=SUPER,2,view,2,0
  bind=SUPER,3,view,3,0
  bind=SUPER,4,view,4,0
  bind=SUPER,5,view,5,0
  bind=SUPER,6,view,6,0
  bind=SUPER,7,view,7,0
  bind=SUPER,8,view,8,0
  bind=SUPER,9,view,9,0

  # tag: move client to the tag and focus it
  # tagsilent: move client to the tag and not focus it
  bind=SUPER+SHIFT,1,tag,1,0
  bind=SUPER+SHIFT,2,tag,2,0
  bind=SUPER+SHIFT,3,tag,3,0
  bind=SUPER+SHIFT,4,tag,4,0
  bind=SUPER+SHIFT,5,tag,5,0
  bind=SUPER+SHIFT,6,tag,6,0
  bind=SUPER+SHIFT,7,tag,7,0
  bind=SUPER+SHIFT,8,tag,8,0
  bind=SUPER+SHIFT,9,tag,9,0

  # monitor switch
  bind=alt+shift,Left,focusmon,left
  bind=alt+shift,Right,focusmon,right
  bind=SUPER+Alt,Left,tagmon,left
  bind=SUPER+Alt,Right,tagmon,right

  # gaps
  bind=ALT+SHIFT,X,incgaps,1
  bind=ALT+SHIFT,Z,incgaps,-1
  bind=ALT+SHIFT,R,togglegaps

  # movewin
  bind=CTRL+SHIFT,Up,movewin,+0,-50
  bind=CTRL+SHIFT,Down,movewin,+0,+50
  bind=CTRL+SHIFT,Left,movewin,-50,+0
  bind=CTRL+SHIFT,Right,movewin,+50,+0

  # resizewin
  bind=CTRL+ALT,Up,resizewin,+0,-50
  bind=CTRL+ALT,Down,resizewin,+0,+50
  bind=CTRL+ALT,Left,resizewin,-50,+0
  bind=CTRL+ALT,Right,resizewin,+50,+0

  # Mouse Button Bindings
  # NONE mode key only work in ov mode
  mousebind=SUPER,btn_left,moveresize,curmove
  mousebind=NONE,btn_middle,togglemaximizescreen,0
  mousebind=SUPER,btn_right,moveresize,curresize
  mousebind=NONE,btn_left,toggleoverview,1
  mousebind=NONE,btn_right,killclient,0

  # Axis Bindings
  axisbind=SUPER,UP,viewtoleft_have_client
  axisbind=SUPER,DOWN,viewtoright_have_client

  # layer rule
  layerrule=animation_type_open:zoom,layer_name:rofi
  layerrule=animation_type_close:zoom,layer_name:rofi;
''
