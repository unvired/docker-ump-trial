# docker-ump3

Dockerfile for the Unvired Mobile Platform container. 

1.  Run the ump-data container first to get the sample database and other configurations with the command: docker run -d --name ump-data unvired/ump-data
2.  Run the ump container and connect to the data container: docker run -d --volumes-from ump-data -p 8080:8080 --name ump unvired/ump
3.  Check if startup is normal and if the server is running: docker logs -f ump
    If no errors are displayed you are good to go
4.  Find the docker host IP with the command: docker-machine ip ump
5.  For e.g. if the output from command in step 4 above was 192.168.99.100 then the platform can be accessed at: http://192.168.99.100:8080/UMP/admin
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
    b. Copy the files sapjco3.jar and libsapjco3.so to the /var/unvired/sapjco folder in the ump-data container with the following commands
       docker cp sapjco3.jar ump-data:/var/unvired/sapjco
       docker cp libsapjco3.so ump-data:/var/unvired/sapjco
9.  If the ump container was started previously, stop it with the command: docker stop ump and remove it: docker rm ump
10. Now start the container with the same command as before (from step 2)
11. UMP will now pick the JCO files that have been copied and be able to connect to SAP.  To test this:
    a. Login to the Unvired Admin Cockpit
    b. Select Backends from the side menu bar.  Then navigate to ports.  From the dropdown select the system "SAP ECC Unvired Customer Search" 
    c. The table below will now display an entry titled "SAP ECC Port - Unvired Customer Search".  Select the row and click on Test Connection.
    d. Enter the credentials and check.  If connectivity succeeds all is good and you can move on to test the mobile application.
    e. If connection test failed an error is displayed, rectify it and try again.  
12  At any point to troubleshoot if you need access to the system log (for e.g if SAP connectivity test failed), use the command: docker logs -f ump to check the log.

