package servercode;

import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;

/*
 * ���ܣ������������棬������ʾ��־�Ϳͻ������������֮��Ľ�����Ϣ
 */
public class ServerMain {

	private CSI_Configuration csiconfig;

	public ServerMain() throws Exception {

		// int port = 8099;// ����������˿ں�
		//
		// ServerSocket s;
		// s = new ServerSocket(port);
		// // ��ʾ����������IP��ַ
		// System.out.println("�������˵�ַ��" + InetAddress.getLocalHost().getHostAddress() +
		// "\n");
		// System.out.println("Server's Services Start.......");
		// System.out.println("Serve socket is" + s.toString());
		// // �������˶��̷߳���
		// try {
		// while (true) {
		// Socket incoming = s.accept();
		// // ��ӡ���ӵĿͻ����׽�����Ϣ
		// System.out.println(incoming.getInetAddress() + ":" + incoming.getPort() +
		// "�ն����ӳɹ����ȴ���¼����������" + "\n");
		// // ��ÿһ�����ӵ��û����������߳�
		// new ServerThreadCode(incoming, csiconfig);
		// }
		// } catch (Exception e1) {
		// // TODO Auto-generated catch block
		// e1.printStackTrace();
		// }
	}

	public void createServer(String csifilename, double samplerate, int duration) {
		csiconfig = new CSI_Configuration(csifilename, samplerate, duration);
		System.out.println("�·�������");
		System.out.println(csifilename + " " + samplerate + " " + duration);
		new Thread() {
			@Override
			public void run() {
				try {

					int port = 8099;// ����������˿ں�
					ServerSocket s;
					s = new ServerSocket(port);
					// ��ʾ����������IP��ַ
					System.out.println("�������˵�ַ��" + InetAddress.getLocalHost().getHostAddress() + "\n");
					System.out.println("Server's Services Start.......");
					System.out.println("Serve socket is " + s.toString());
					// �������˶��̷߳���

					while (true) {
						System.out.println("��while����");
						Socket incoming = s.accept();
						// ��ӡ���ӵĿͻ����׽�����Ϣ
						System.out.println(
								incoming.getInetAddress() + ":" + incoming.getPort() + "�ն����ӳɹ����ȴ���¼����������" + "\n");
						// ��ÿһ�����ӵ��û����������߳�
						new ServerThreadCode(incoming, csiconfig);
					}

				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}// Thread run()
		}.start();
	}

	public static void main(String[] args) throws Exception {

		// new Thread() {
		// @Override
		// public void run() {
		// try {
		// new ServerMain("111", 0.01, 100);
		// } catch (Exception e) {
		// // TODO Auto-generated catch block
		// e.printStackTrace();
		// }
		// }// Thread run()
		// }.start();
		// new ServerMain("111", 0.01, 111);
		// int port = 8099;// ����������˿ں�
		// new ServerMain();
		// ServerSocket s;
		// s = new ServerSocket(port);
		// // ��ʾ����������IP��ַ
		// System.out.println("�������˵�ַ��" + InetAddress.getLocalHost().getHostAddress() +
		// "\n");
		// System.out.println("Server's Services Start.......");
		// System.out.println("Serve socket is" + s.toString());
		// // �������˶��̷߳���
		// try {
		// while (true) {
		// Socket incoming = s.accept();
		// // ��ӡ���ӵĿͻ����׽�����Ϣ
		// System.out.println(incoming.getInetAddress() + ":" + incoming.getPort() +
		// "�ն����ӳɹ����ȴ���¼����������" + "\n");
		// // ��ÿһ�����ӵ��û����������߳�
		// new ServerThreadCode(incoming);
		// }
		// } catch (Exception e1) {
		// // TODO Auto-generated catch block
		// e1.printStackTrace();
		// }

	}

}
