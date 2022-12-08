#!/bin/bash 

TTL=48 
R='false'


exit_abnormal() {                         # Function: Exit with error.
  echo "Usage: freespace [-r] [-t ###] file [file...]" 1>&2 
  exit 1
}

function handleFcFile(){
  # If file is called `fc-*` AND is older than TTL hours, `rm` it.
  if [[ $1 == "fc-"* ]] && [ $(find $1 -mmin +$[60*$TTL]) ]; then
      rm $1
  fi  
}

function handleFile(){
  # The file is zipped, tgzed, bzipped or compressed
  if [[ $(file $1) == *'Zip'* ]] || \
      [[ $(file $1) == *'gzip'* ]] || \
      [[ $(file $1) == *'bzip2'* ]] || \
      [[ $(file $1) == *"compress'd"* ]]; then
      # change the file name to start with 'fc-'
      mv $1 fc-${1}
      touch fc-${1}
  else
      # file not compressed
      if [ -f $1 ]; then
          zip fc-${1} $1
          rm $1
      fi
  fi
}

function freespace(){
  if [ -d $1 ]; then
    # move to directory
    pushd $1 1> /dev/null
    for file in *; do
      if [[ $R  == 'true' && -d $file ]]; then
        freespace $file
      else 
        handleFcFile $file
        handleFile $file
      fi
      
    done
    # return to original dir
    popd 1> /dev/null
  else 
      handleFcFile $1
      handleFile $1
  fi
}




while getopts ":rt:" options; do         # Loop: Get the next option;
                                          # use silent error checking;
                                         # options n and t take arguments.
  case "${options}" in                    # 
    r)                                    # If the option is r,
      R='true'
      ;;
    t)                                    # If the option is t,
      TTL=${OPTARG}                     # Set $TIMES to specified value.
      re_isanum='^[0-9]+$'                # Regex: match whole numbers only
      if ! [[ $TTL =~ $re_isanum ]] ; then   # if $TIMES not whole:
        echo "Error: TIMES must be a positive, whole number."
        exit_abnormal
      elif [ $TTL -eq "0" ]; then       # If it's zero:
        echo "Error: TIMES must be greater than zero."
        exit_abnormal                     # Exit abnormally.
      fi
      ;;
    :)                                    # If expected argument omitted:
      echo "Error: -${OPTARG} requires an argument."
      exit_abnormal                       # Exit abnormally.
      ;;
    file)                                    # If unknown (any other) option:
      filename=${OPTARG}
      ;;
    *)                                    # If unknown (any other) option:
      exit_abnormal                       # Exit abnormally.
      ;;
  esac
done

shift $((OPTIND-1))                       # unsetting the flags 


if [ $1 != 'file' ];                   
then
    exit_abnormal
fi




# start program
file_name=$2
freespace $file_name



