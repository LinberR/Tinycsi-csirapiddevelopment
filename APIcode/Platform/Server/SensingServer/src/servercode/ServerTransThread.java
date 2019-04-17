package servercode;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;

/*
 * ���ܣ������������û����󼰷��Ϳ����ź�
 */
class ServerThreadCode extends Thread {
	private Socket clientSocket = null;// �ͻ��׽���
	private BufferedReader sin = null;// �����װ�׽���������
	private PrintWriter sout = null;// �����װ�׽��������

	String Username = null;// �û���
	String DeviceID = null;// �豸��
	private boolean isDevice = false;
	ControlWindow cw = null;

	public ServerThreadCode(Socket s, CSI_Configuration csiconfig) throws IOException {

		this.clientSocket = s;

		try {
			sin = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
			sout = new PrintWriter(new BufferedWriter(new OutputStreamWriter(clientSocket.getOutputStream())), true);
			start();// �����߳�
		} catch (Exception e) {
		}
	}

	public void run() {

		for (;;)// һֱ���ܰ�׿����Ϣ
		{
			try {
				String str = sin.readLine();// ������
				System.out.println("���������ݣ�" + str + "\n");
				if (str == null) {
					// д����־���������˳�����
					System.out.println(Username + "(��׿��)�ر��׽���,�˳�����" + "\n");
					cw.setVisible(false);
					break;
				}
				// �豸��¼
				if (str.startsWith("<LOGIN>")) {
					System.out.println("����ָ��Ϊ��<LOGIN>\n");
					String msg = str.substring(7);// ��ȡ�����û������û�������ַ���
					String[] order = msg.split("\\|");// �á�|���ָ�
					Username = order[0];// ����û���

					System.out.println("�û��� " + Username + "����\n");

					sout.println("ok");
					sout.flush();
					// ������ƴ���,���������̲߳ſ����밲׿����ת֮���ҳ��activity(Android_Control)��service����ͨ��
					new Thread() {
						@Override
						public void run() {
							try {
								cw = new ControlWindow(Username, clientSocket);
								cw.setVisible(true);
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}// Thread run()
					}.start();

				} // if(<LOGIN>)
				else if (str.startsWith("<HeartBeatTest>")) {

					// showArea.append("��������������Ƿ�����\n");

				}

				else {
					// �������˳�����
					System.out.println("�û��� " + Username + "�˳�\n");
				}

			} catch (IOException e) {
				// ͨ��ʹ�����������Ƽ��ͻ������������Ƿ�����
				// �������˽��ճ�ʱʱ��Ϊ5s���ͻ���ÿ��1s����һ��������������Ӱ������ͨ��
				System.out.println(Username + " �ͻ�������Ͽ��������߳�\n");

				System.out.println(Username + "������ֹ" + "\n");

				cw.setVisible(false);

				break;
			}

		} // for
	}
}
