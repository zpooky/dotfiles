#!/bin/bash

l_pwd="${1}"
name="#W"
l_dists="/home/fredriol/dists"

#  black, red, green, yellow, blue, magenta, cyan, white; if supported the
#  bright variants brightred, brightgreen, brightyellow

# echo ${l_pwd} >> /tmp/wasd
if [[ "${l_pwd}" =~ ^${l_dists}/* ]]; then
  stripped=${l_pwd#"${l_dists}"}
  dist=$(echo "${stripped}" | cut -d "/" -f2)
  builds="${l_dists}/${dist}/builds"
  build=""
  workspace=""

  if [[ "${l_pwd}" =~ ^${builds}/* ]]; then
    stripped=${l_pwd#"${l_dists}/${dist}/builds"}
    build=$(echo "${stripped}" | cut -d "/" -f2)
    if [[ "${l_pwd}" =~ ^${builds}/${build}/workspace/sources/([a-zA-Z0-9_\.-]+) ]]; then
      workspace=":#[fg=green]${BASH_REMATCH[1]}"
    fi
  elif [[ -e ${builds} ]]; then
    files=${builds}/*
    if [ ${#files[@]} -gt 0 ]; then
      sep=""
      for f in $files; do
        build="${build}${sep}$(basename ${f})"
        sep=","
      done
    fi
  fi

  if [ ! -z ${build} ]; then
    if [ "${build}" != "${dist}" ]; then
      name="${dist}:#[fg=cyan]${build}${workspace}"
    fi
  fi
fi

# name="$(basename ${PWD})"

echo "#[fg=yellow,bold]#I#[fg=white]:${name}#{?window_zoomed_flag,#[fg=blue]+Z,}"

#   alternate_on                    If pane is in alternate screen
#   alternate_saved_x               Saved cursor X in alternate screen
#   alternate_saved_y               Saved cursor Y in alternate screen
#   buffer_created                  Time buffer created
#   buffer_name                     Name of buffer
#   buffer_sample                   Sample of start of buffer
#   buffer_size                     Size of the specified buffer in bytes
#   client_activity                 Time client last had activity
#   client_created                  Time client created
#   client_control_mode             1 if client is in control mode
#   client_discarded                Bytes discarded when client behind
#   client_height                   Height of client
#   client_key_table                Current key table
#   client_last_session             Name of the client's last session
#   client_name                     Name of client
#   client_pid                      PID of client process
#   client_prefix                   1 if prefix key has been pressed
#   client_readonly                 1 if client is readonly
#   client_session                  Name of the client's session
#   client_termname                 Terminal name of client
#   client_termtype                 Terminal type of client
#   client_tty                      Pseudo terminal of client
#   client_utf8                     1 if client supports utf8
#   client_width                    Width of client
#   client_written                  Bytes written to client
#   command                         Name of command in use, if any
#   command_list_name               Command name if listing commands
#   command_list_alias              Command alias if listing commands
#   command_list_usage              Command usage if listing commands
#   cursor_flag                     Pane cursor flag
#   cursor_character                Character at cursor in pane
#   cursor_x                        Cursor X position in pane
#   cursor_y                        Cursor Y position in pane
#   history_bytes                   Number of bytes in window history
#   history_limit                   Maximum window history lines
#   history_size                    Size of history in lines
#   hook                            Name of running hook, if any
#   hook_pane                       ID of pane where hook was run, if any
#   hook_session                    ID of session where hook was run, if
#                                   any
#   hook_session_name               Name of session where hook was run, if
#                                   any
#   hook_window                     ID of window where hook was run, if any
#   hook_window_name                Name of window where hook was run, if
#                                   any
#   host                   #H       Hostname of local host
#   host_short             #h       Hostname of local host (no domain name)
#   insert_flag                     Pane insert flag
#   keypad_cursor_flag              Pane keypad cursor flag
#   keypad_flag                     Pane keypad flag
#   line                            Line number in the list
#   mouse_any_flag                  Pane mouse any flag
#   mouse_button_flag               Pane mouse button flag
#   mouse_standard_flag             Pane mouse standard flag
#   mouse_all_flag                  Pane mouse all flag
#   pane_active                     1 if active pane
#   pane_at_bottom                  1 if pane is at the bottom of window
#   pane_at_left                    1 if pane is at the left of window
#   pane_at_right                   1 if pane is at the right of window
#   pane_at_top                     1 if pane is at the top of window
#   pane_bottom                     Bottom of pane
#   pane_current_command            Current command if available
#   pane_current_path               Current path if available
#   pane_dead                       1 if pane is dead
#   pane_dead_status                Exit status of process in dead pane
#   pane_format                     1 if format is for a pane (not assuming
#                                   the current)
#   pane_height                     Height of pane
#   pane_id                #D       Unique pane ID
#   pane_in_mode                    If pane is in a mode
#   pane_input_off                  If input to pane is disabled
#   pane_index             #P       Index of pane
#   pane_left                       Left of pane
#   pane_mode                       Name of pane mode, if any.
#   pane_pid                        PID of first process in pane
#   pane_pipe                       1 if pane is being piped
#   pane_right                      Right of pane
#   pane_search_string              Last search string in copy mode
#   pane_start_command              Command pane started with
#   pane_synchronized               If pane is synchronized
#   pane_tabs                       Pane tab positions
#   pane_title             #T       Title of pane
#   pane_top                        Top of pane
#   pane_tty                        Pseudo terminal of pane
#   pane_width                      Width of pane
#   pid                             Server PID
#   rectangle_toggle                1 if rectangle selection is activated
#   scroll_region_lower             Bottom of scroll region in pane
#   scroll_region_upper             Top of scroll region in pane
#   scroll_position                 Scroll position in copy mode
#   selection_present               1 if selection started in copy mode
#   session_alerts                  List of window indexes with alerts
#   session_attached                Number of clients session is attached
#                                   to
#   session_activity                Time of session last activity
#   session_created                 Time session created
#   session_format                  1 if format is for a session (not
#                                   assuming the current)
#   session_last_attached           Time session last attached
#   session_group                   Name of session group
#   session_group_size              Size of session group
#   session_group_list              List of sessions in group
#   session_grouped                 1 if session in a group
#   session_id                      Unique session ID
#   session_many_attached           1 if multiple clients attached
#   session_name           #S       Name of session
#   session_stack                   Window indexes in most recent order
#   session_windows                 Number of windows in session
#   socket_path                     Server socket path
#   start_time                      Server start time
#   version                         Server version
#   window_activity                 Time of window last activity
#   window_activity_flag            1 if window has activity
#   window_active                   1 if window active
#   window_bell_flag                1 if window has bell
#   window_bigger                   1 if window is larger than client
#   window_end_flag                 1 if window has the highest index
#   window_flags           #F       Window flags
#   window_format                   1 if format is for a window (not
#                                   assuming the current)
#   window_height                   Height of window
#   window_id                       Unique window ID
#   window_index           #I       Index of window
#   window_last_flag                1 if window is the last used
#   window_layout                   Window layout description, ignoring
#                                   zoomed window panes
#   window_linked                   1 if window is linked across sessions
#   window_name            #W       Name of window
#   window_offset_x                 X offset into window if larger than
#                                   client
#   window_offset_y                 Y offset into window if larger than
#                                   client
#   window_panes                    Number of panes in window
#   window_silence_flag             1 if window has silence alert
#   window_stack_index              Index in session most recent stack
#   window_start_flag               1 if window has the lowest index
#   window_visible_layout           Window layout description, respecting
#                                   zoomed window panes
#   window_width                    Width of window
#   window_zoomed_flag              1 if window is zoomed
#   wrap_flag                       Pane wrap flag
