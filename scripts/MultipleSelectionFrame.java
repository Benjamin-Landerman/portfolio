import java.awt.FlowLayout;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JButton;
import javax.swing.JScrollPane;
import javax.swing.ListSelectionModel;

public class MultipleSelectionFrame extends JFrame {
    private JList<String> burgerJList;
    private JList copyJList;
    private JButton copyJButton;
    private static final String[] burgerNames =
    {"Mushroom", "Onion and Cheese", "Red Pepper and Bacon", "Italian", "Lip Smacker", "Texan", "Californian", "Chili", "Bleu Cheese", "Fried Egg", "Triple Threat", "Veggie"};
    public MultipleSelectionFrame() {
        super("Multiple Selection Lists");
        setLayout( new FlowLayout() );
        burgerJList = new JList<>(burgerNames);
        burgerJList.setVisibleRowCount(5);
        burgerJList.setFixedCellWidth(140);
        burgerJList.setFixedCellHeight(15);
        burgerJList.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);

        add(new JScrollPane(burgerJList));
        copyJButton = new JButton("Copy >>>");
        copyJButton.addActionListener(
            new ActionListener() {
                public void actionPerformed(ActionEvent event) {
                    copyJList.setListData(burgerJList.getSelectedValues());
                }
            }
        );
        add(copyJButton);
        copyJList = new JList();

        copyJList.setVisibleRowCount(5);
        copyJList.setFixedCellWidth(140);
        copyJList.setFixedCellHeight(15);
        copyJList.setSelectionMode(ListSelectionModel.SINGLE_INTERVAL_SELECTION);
        add(new JScrollPane(copyJList));
    }
}