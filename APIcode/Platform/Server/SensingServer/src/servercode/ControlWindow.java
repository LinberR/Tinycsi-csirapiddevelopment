package servercode;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

/*
 * ���ܣ��������˵���ģ�����ִ��ڣ���׿�˷���������Ϣ
 *      ��Ӷ�ȡ�ļ����������Դ�matlab����õ���fifo�ļ��ж�ȡ���ݣ�����Android����֪ͨ
 */

public class ControlWindow extends JFrame {
	private Socket socket;// ͨ���׽���
	private BufferedReader sin;
	private PrintWriter sout;// ����ָ��
	private String username;

	JLabel showStateInfo = new JLabel("");

	// ��ö����ַ�������
	public String getString(BufferedReader sin) throws IOException {
		try {
			String str = sin.readLine();
			return str;
		} catch (Exception e) {
			if (e instanceof java.net.SocketException) {
				setVisible(false);
			}
		}
		return null;
	}

	public ControlWindow(String name, Socket s) throws IOException {

		this.socket = s;
		this.username = name;

		showStateInfo.setOpaque(true);
		showStateInfo.setBackground(Color.WHITE);
		sin = new BufferedReader(new InputStreamReader(s.getInputStream()));
		sout = new PrintWriter(new BufferedWriter(new OutputStreamWriter(this.socket.getOutputStream())), true);
		setTitle("���ƴ���");
		setSize(300, 300);
		JPanel mJPanel = new JPanel();
		mJPanel.setLayout(new GridLayout(3, 1));
		JLabel showInfo = new JLabel("�û�����" + username, JLabel.CENTER);
		JButton GetCSI = new JButton("��ʼ�ɼ�CSI");
		JButton StopCSI = new JButton("ֹͣ�ɼ�CSI");

		// ��������
		showInfo.setOpaque(true);
		showInfo.setFont(new Font("����", Font.PLAIN, 18));
		showInfo.setBackground(Color.WHITE);

		mJPanel.add(showInfo);
		mJPanel.add(GetCSI);
		mJPanel.add(StopCSI);

		add(mJPanel, BorderLayout.CENTER);

		// ��ʼ�ɼ�CSI
		GetCSI.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				sout.println("get_csi");
				sout.flush();
				System.out.println("��ʼ�ɼ�CSI\n");
			}

		});

		// ֹͣ�ɼ�CSI
		StopCSI.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				sout.println("stop_get_csi");
				sout.flush();
				System.out.println("ֹͣ�ɼ�CSI\n");

			}
		});

		// System.out.println(txt2String(file));
		setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		// ��Ӵ��ڹر��¼�
		addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				int selection = JOptionPane.showConfirmDialog(ControlWindow.this, "��Ҫ�Ͽ����Ӳ��˳���", "��ʾ",
						JOptionPane.OK_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE);
				if (selection == JOptionPane.OK_OPTION) {
					try {
						sout.close();
						socket.close();
						System.out.println(username + "(��������)�ر��׽���,�˳�����" + "\n");

						// д����־��������(��������)�ر��׽���,�˳�����
						setVisible(false);
					} catch (IOException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
				}
			}

		});

		// ���ܰ�׿����Ϣ���߳�,�����ж��׽����Ƿ�����
		// new Thread() {
		// @Override
		// public void run() {
		// try {
		// while (true) {
		// String result;
		// result = getString(sin);
		// if (result == null) {
		// // д����־���������˳�����
		// System.out.println(username + "(��׿��)�ر��׽���,�˳�����" + "\n");
		// testdb.onlineUser_do(username, 1);// �����߱���ɾȥ�������ߵ��û�
		// setVisible(false);
		// break;
		// }
		// }
		// } catch (IOException e) {
		// // TODO Auto-generated catch block
		// e.printStackTrace();
		// }
		// }
		// }.start();

		setResizable(false);// ���ô��ڲ��ɵ��ڴ�С
		setLocationRelativeTo(null); // ������ʾ
	}

}
