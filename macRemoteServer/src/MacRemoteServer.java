
import java.net.*;
import java.io.*;
import java.awt.event.KeyEvent;
import java.awt.*;

public class MacRemoteServer {

    //Define the keys
    final static int right = KeyEvent.VK_RIGHT;
    final static int left = KeyEvent.VK_LEFT;
    final static int space = KeyEvent.VK_SPACE;
    final static int enter = KeyEvent.VK_ENTER;
    final static int esc = KeyEvent.VK_ESCAPE;
    final static int cmd = KeyEvent.VK_META;
    final static int ctrl = KeyEvent.VK_CONTROL;
    final static int f = KeyEvent.VK_F;

    //Attributes for client-server connection
    ServerSocket server;
    Socket client;

    //Robot for keyboard simulation
    Robot robot;

    //Constructor
    MacRemoteServer() throws Exception {
        server = new ServerSocket(789);
        robot = new Robot();
    }

    public static void main(String[] args) throws Exception {

        MacRemoteServer macRemoteServer = new MacRemoteServer();

        //connect to the client and read the messages
        macRemoteServer.connect();
    }

    void connect() throws Exception {
        while(true) {
            client = server.accept();
            BufferedReader inFromClient = new BufferedReader(new InputStreamReader(client.getInputStream()));
            System.out.println("Connected");

            String clientMessage;
            while((clientMessage = inFromClient.readLine()) != null) {
                //System.out.println(clientMessage);
                switch(clientMessage) {
                    //PowerPoint
                    case "nextSlide": executeAction(right); break;
                    case "previousSlide": executeAction(left); break;
                    case "startPresentation": executeAction(cmd, enter); break;
                    case "endPresentation": executeAction(esc); break;
                    //Netflix
                    case "pausePlay": executeAction(space); break;
                    //Photos
                    case "nextPic": executeAction(right); break;
                    case "previousPic": executeAction(left); break;
                    case "fullScreen": executeAction(cmd, ctrl, f); break;
                    case "selectPic": executeAction(enter); break;
                    //Spotify
                    case "nextTrack": executeAction(cmd, right); break;
                    case "previousTrack": executeAction(cmd, left); break;
                    //Desktop
                    case "leftDesktop": executeAction(ctrl, left); break;
                    case "rightDesktop": executeAction(ctrl, right); break;
                    default: break;
                }
            }

            client.close();
            System.out.println("Disconnected");
        }
    }

    void executeAction(int singleKey) throws Exception {
        robot.keyPress(singleKey);
        Thread.sleep(20);
        robot.keyRelease(singleKey);
    }

    void executeAction(int firstKey, int secondKey) throws Exception {
        robot.keyPress(firstKey);
        Thread.sleep(20);
        robot.keyPress(secondKey);
        Thread.sleep(20);
        robot.keyRelease(secondKey);
        Thread.sleep(20);
        robot.keyRelease(firstKey);
    }

    void executeAction(int firstKey, int secondKey, int thirdKey) throws Exception {
        robot.keyPress(firstKey);
        Thread.sleep(20);
        robot.keyPress(secondKey);
        Thread.sleep(20);
        robot.keyPress(thirdKey);
        Thread.sleep(20);
        robot.keyRelease(thirdKey);
        Thread.sleep(20);
        robot.keyRelease(secondKey);
        Thread.sleep(20);
        robot.keyRelease(firstKey);
    }
}




