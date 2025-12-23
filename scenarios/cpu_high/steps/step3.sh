
---


```md
## Step 3 – Fix the Issue

Stop Or kill the process by using kill command

```bash
kill -9 <PID>

AGAIN RUN TOP OR PS COMMAND TO CHECK PIDS BEEN KILLED AND %CPU HAS REDUCED BY USING BELOW COMMAND
ps -eo pid,cmd,%cpu --sort=-%cpu | head

NOW THE %CPU SHOULD HAVE BEEN REDUCED, IF NOT CONTINUE FROM STEP 1.
