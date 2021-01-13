#!/bin/bash

source /environment.sh

# initialize launch file
dt-launchfile-init

# YOUR CODE BELOW THIS LINE
# ----------------------------------------------------------------------------


# NOTE: Use the variable DT_REPO_PATH to know the absolute path to your code
# NOTE: Use `dt-exec COMMAND` to run the main process (blocking process)

# launching app
dt-exec echo "This is an empty launch script. Update it to launch your application."

dt-exec /bin/bash -c "jupyter lab --ip 0.0.0.0 --port 8888 --allow-root &> /var/log/jupyter.log" & \
	    echo "allow 10 sec for JupyterLab to start @ http://localhost:8888 (password quackquack)" && \
	    echo "JupterLab logging location:  /var/log/jupyter.log  (inside the container)" && \
	    /bin/bash

# ----------------------------------------------------------------------------
# YOUR CODE ABOVE THIS LINE

# wait for app to end
dt-launchfile-join
