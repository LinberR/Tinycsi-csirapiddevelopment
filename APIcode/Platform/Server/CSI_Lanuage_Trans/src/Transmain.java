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
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.filechooser.FileSystemView;

public class Transmain extends JFrame {

	static JButton submit = new JButton("�ύ����");
	static JButton startTrans = new JButton("��ʼת��");
	static JButton check = new JButton("�鿴����m�ű�");
	static JButton startadjust = new JButton("��ʼ����m�ű�������");
	String path = null;
	String DesktopPath = null;
	String newmfilePath = null;
	String csifunctuion = null;
	static JTextArea showArea = new JTextArea();

	public Transmain() {

		showArea.append("��������" + "\n");
		setTitle("����ת������");
		setSize(600, 400);
		showArea.setEditable(false);
		JLabel timechange = new JLabel();
		add(timechange, BorderLayout.NORTH);
		JScrollPane jslp = new JScrollPane(showArea); // �ӹ�����
		jslp.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
		showArea.setFont(new Font("����", Font.PLAIN, 16));
		showArea.setForeground(Color.black);
		JPanel control = new JPanel();

		control.setLayout(new GridLayout(1, 4));
		control.add(submit);
		control.add(startTrans);
		control.add(check);
		control.add(startadjust);
		add(jslp, BorderLayout.CENTER);
		add(control, BorderLayout.SOUTH);
		// ѡ��Ҫת�����ļ�
		submit.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				int result = 0;
				File file = null;
				JFileChooser fileChooser = new JFileChooser();
				FileSystemView fsv = FileSystemView.getFileSystemView(); // ע���ˣ�������Ҫ��һ��
				// System.out.println(fsv.getHomeDirectory()); // �õ�����·��
				DesktopPath = fsv.getHomeDirectory().getPath();
				System.out.println("����·����" + DesktopPath); // �õ�����·��
				fileChooser.setCurrentDirectory(fsv.getHomeDirectory());
				fileChooser.setDialogTitle("��ѡ��Ҫ�ϴ����ļ�...");
				fileChooser.setApproveButtonText("ȷ��");
				fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
				result = fileChooser.showOpenDialog(fileChooser);
				if (JFileChooser.APPROVE_OPTION == result) {
					path = fileChooser.getSelectedFile().getPath();
					System.out.println("��ȡ�ļ���·��path: " + path);
				}
			}
		});
		// ��ʼת��
		startTrans.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {

				try {
					String encoding = "GBK";
					File file = new File(path);
					// ��ʼ��һЩȫ�ֱ���
					String a[] = { "addpath('APILibrary');\n", "addpath('toolScripts');\n", "global f;\n",
							"global count;\n", "global csiSubc;\n", "global varSilent;\n", "count=0;\n",
							"varSilent=0;\n", "csiSubc=0;\n" };
					// ���ɵ�m�ű�����·���������֣�1.���ɵ������ϡ�2�����ɵ���ǰ�ļ����£�
					// File new_mfile = new File(DesktopPath + "/CSInewfile.m");
					// newmfilePath = new String(DesktopPath + "/CSInewfile.m");
					File new_mfile = new File("CSInewfile.m");
					newmfilePath = new String("CSInewfile.m");

					if (!new_mfile.exists()) {
						try {

							System.out.println("m�ű��ļ������ڣ���ʼ����");
							new_mfile.createNewFile();

						} catch (IOException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}
					}

					FileWriter fw = new FileWriter(new_mfile, false);
					BufferedWriter bufw = new BufferedWriter(fw);

					if (file.isFile() && file.exists()) { // �ж��ļ��Ƿ����
						InputStreamReader read = new InputStreamReader(new FileInputStream(file), encoding);// ���ǵ������ʽ
						BufferedReader bufferedReader = new BufferedReader(read);
						String lineTxt = null;

						while ((lineTxt = bufferedReader.readLine()) != null) {
							System.out.println(lineTxt);
							if (lineTxt.indexOf("main_function") != -1) {

								int begin = lineTxt.indexOf("main_function");
								String temp = lineTxt.substring(begin + 14);
								// ��Ӻ�����
								// temp = "function ret=" + temp + "(handles)\n";
								temp = "function ret=" + "CSInewfile" + "(handles)\n";
								csifunctuion = temp;
								bufw.write(temp);
								bufw.newLine();
								// ��ӳ�ʼ������
								for (int k = 0; k < a.length; k++) {
									bufw.write(a[k]);
									bufw.newLine();
								}
								// ��Ӷ�ȡfifo�ļ�ģ��
								bufw.write("Openfile('csififo.fifo');\n");
								bufw.newLine();

							} else if (lineTxt.indexOf("CSI_sampleSetting") != -1) {
								// ��ʱ��û�����ôд
							} else if (lineTxt.indexOf("loop()") != -1) {

								bufw.write("while 1\n");
								bufw.newLine();
							} else if (lineTxt.indexOf("CSI_IntrusionTest_oneChannelThreshold") != -1) {
								bufw.write("IntrusionTest_oneChannelThreshold(handles,15,5,5,1);\n");
								bufw.newLine();
							}
						}

						bufw.write("end\n");
						bufw.newLine();
						bufw.write("fclose(f);\n");
						bufw.newLine();
						bufw.write("end\n");
						bufw.newLine();
						read.close();
						bufw.close();
						fw.close();
						// �������������m�ű��ļ��������Ҫ����GUI�ļ�����������GUI�ĺ���

						GetGUI();
					} else {
						System.out.println("�Ҳ���ָ�����ļ�");
					}
				} catch (UnsupportedEncodingException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				} catch (FileNotFoundException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});

		// �鿴ת������ļ�
		check.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					Runtime.getRuntime().exec("notepad " + newmfilePath);
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				} // �޸������1.txtΪ���Լ����ı��ļ���
			}
		});

		// ����shell�ű�����GUI����
		startadjust.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				new Thread() {
					@Override
					public void run() {
						try {
							File directory = new File("");
							String testString = directory.getCanonicalPath();
							String shpath = testString + "/Start_Adjust_All.sh";
							Process ps;
							ps = Runtime.getRuntime().exec(shpath);
							if (ps == null) {
								JOptionPane.showMessageDialog(null, "�ļ�������", "�ű�������", JOptionPane.ERROR_MESSAGE);
							}
							ps.waitFor();
							showArea.append("�������" + "\n");
						} catch (IOException | InterruptedException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}
					}
				}.start();
			}
		});

		// ��ֹֻҪ���������С���͹ر�������
		// Frame���ڵ�С���Ĭ�Ͼ��ǵ���͹رգ�����������ѡ��ʲô������رգ�һ��Ҫ��ǰ���ڵĹ��캯�������һ�仰
		// frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);������ȡ��Ҳ��رմ��ڣ�
		setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		// ��Ӵ��ڹر��¼�
		addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				int selection = JOptionPane.showConfirmDialog(Transmain.this, "��Ҫ�˳���", "��ʾ",
						JOptionPane.OK_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE);
				if (selection == JOptionPane.OK_OPTION) {
					System.exit(0);

				} else {
					// setVisible(true);
				}
			}
		});
		setLocationRelativeTo(null); // ������ʾ
		setResizable(false);// ���ڲ��ɵ��ڴ�С
		setVisible(true);// ����������ʾ
	}

	public static void main(String[] args) throws Exception {
		new Transmain();

	}

	public void GetGUI() throws IOException {
		// ��׼��GUI�ļ�
		File file = new File("guiStandard.m");
		String encoding = "GBK";
		// ���csifunction���ɵ�GUI�ļ�
		File new_guifile = new File("myguitest.m");

		if (!new_guifile.exists()) {
			try {

				System.out.println("GUI�ű��ļ������ڣ���ʼ����");
				new_guifile.createNewFile();

			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		FileWriter fw = new FileWriter(new_guifile, false);
		BufferedWriter bufw = new BufferedWriter(fw);

		if (file.isFile() && file.exists()) { // �ж��ļ��Ƿ����
			InputStreamReader read = new InputStreamReader(new FileInputStream(file), encoding);// ���ǵ������ʽ
			BufferedReader bufferedReader = new BufferedReader(read);
			String lineTxt = null;
			while ((lineTxt = bufferedReader.readLine()) != null) {

				if (lineTxt.indexOf("%recorder(gcf,handles);") != -1) {

					bufw.write("CSInewfile(handles);\n");
					bufw.newLine();
				} else {

					bufw.write(lineTxt);
					bufw.newLine();
				}

			}
			// ǧ��ע��Ҫ��close()��������Ȼ�޷�������д���ı�����
			read.close();
			bufw.close();
			fw.close();
		}
	}

}
