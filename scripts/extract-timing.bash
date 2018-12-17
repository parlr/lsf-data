#!/usr/bin/env bash
# USAGE
#   bash -x ./scripts/extract-timing.bash "$path/to/subtitle.ass"

IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"
FAIL=1

extract-timing-from-subtitles() {
  if [[ $# -eq 0 ]] ; then
      echo 'missing argument: subtitle_filepath'
      exit $FAIL
  fi
  
  subtitle_filepath="$1"  # contains timing as a subtitles file
  timing_filepath="${subtitle_filepath/.ass/.tsv}"  # timing, as: mot  start_time end_time

  awk -f <(cat - <<-'EOD'
    BEGIN{FS=","} 
    /Dialogue/{
      output=0$2" 0"$3" "$10; 
      for (field=11; field<=NF; field++) {
        output=output","$field
      }; 
      print output
    }
EOD
) "$subtitle_filepath" > "$timing_filepath"
}

if [[ $IS_RUNNING_TESTS == false ]]; then extract-timing-from-subtitles "$@"; fi
