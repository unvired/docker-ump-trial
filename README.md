# docker-ump3

Dockerfile for the Unvired Mobile Platform container. 

1.  Run the ump-data container first to get the sample database and other configurations with the command: docker run -d --name trialdb unvired/ump-trialdb
2.  Run the ump container and connect to the data container: docker run -d --volumes-from trialdb -p 8080:8080 --name ump unvired/ump-trial
3.  Check if startup is normal and if the server is running: docker logs -f ump
    If no errors are displayed you are good to go
    Hint: Wait for some redis/pub-sub messages to show up in the log.
4.  Find the docker host IP with the command: docker-machine ip ump
5.  For e.g. if the output from command in step 4 above was 192.168.99.100 then the platform can be accessed at: http://192.168.99.100:8080/UMP/admin
	The initial screen will request for a license. Please provide the required details and register for a free trial.  Upload the trial license received to continue.
6.  Login to the Unvired Admin Cockpit - The default login details are:
    Company : UNVIRED
    User: SA
    Password: unvired
7.  Base configuration:
    a. Login to the Unvired Admin Cockpit
    b. Select Backends from the side menu bar.  Then edit the system called ME. 
    c. Change the property called APP_SERVER to the IP address from step 4 above, for e.g. 192.168.99.100
8.  To use the SAP Customer Search example application (Source code available on GitHub), you will need to copy the SAP JCO Jar file and Linux platform binary.  To do that:
    a. Download the SAPJCO3 distribution file from the SAP Download Portal using your customer ID.  You will need to download the file named sapjco30<build>_Linux86_64.zip
    b. Copy the files sapjco3.jar and libsapjco3.so to a local directory on your system like /home/unvired/sapjco folder.
9.  If the ump container was started previously, stop it with the command: docker stop ump and remove it: docker rm ump
10. Now start the container with the command: docker run -d --volumes-from trialdb -v /home/unvired/sapjco:/var/UMPinput -p 8080:8080 --name ump unvired/ump-trial
11. UMP will now pick the JCO files from your local folder (and mounted as /var/UMPinput) within the container.  To test this:
    a. Login to the Unvired Admin Cockpit
    b. Select Backends from the side menu bar.  Select the "SAP ECC Unvired Customer Search" entry and make sure the system IP address or domain name, system name etc are set correctly.
    c. Then navigate to ports.  From the dropdown select the system "SAP ECC Unvired Customer Search".
    d. The table below will now display an entry titled "SAP ECC Port - Unvired Customer Search".  Select the row and click on edit.
    e. Set the client and other details correctly and save.
    e. Now select the row displaying the SAP ECC port and click on Test Connection.
    d. Enter the credentials and check.  If connectivity succeeds all is good and you can move on to test the mobile application.
    e. If connection test failed an error is displayed, rectify it and try again.  
    f. Make sure the correct local directory has been passed to the volume mount point.
12  At any point to troubleshoot if you need access to the system log (for e.g if SAP connectivity test failed), use the command: docker logs -f ump to check the log.

Note: To keep the trial simple, H2 embedded database via the unvired/ump-trialdb data container is provided.  Also the required services are configured to run within the ump-trial
container (like redis and sentinel) via supervisord.