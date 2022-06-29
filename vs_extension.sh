backup_restore() {

    read -p "Do you want to (b)ackup or (r)estore extensions? (b/r) " answer
    echo

    count_extensions=$(wc -l extensions.txt | awk '{print $1}')

    if [ "$answer" = "b" ]; then
        # if extension.txt is there create a backup of it
        if (ls | grep extensions.txt >/dev/null); then
            cp extensions.txt extensions.txt.bak
            # echo "Backup of extensions.txt created"
        fi

        code --list-extensions > extensions.txt
        clear

        echo "$count_extensions Extensions backed up to extensions.txt"
        # count_extensions=$(wc -l extensions.txt | awk '{print $1}')

        undo_backup_fun(){
            # undo the the extension.txt and rollback to the backup
            echo
            read -p "Do you want to undo the extensions.txt and rollback to the backup? (y/n) " undo_backup
            if [ "$undo_backup" = "y" ]; then
                rm extensions.txt
                mv extensions.txt.bak extensions.txt
                clear
                echo "Rolled-back successfully to the previous extensions list"
            elif [ "$undo_backup" = "n" ]; then
                echo "Extensions.txt not rolled back"> /dev/null
            else
                echo "Invalid input, Please enter y or n"
                undo_backup_fun
            fi
        }
        undo_backup_fun

    elif [ "$answer" = "r" ]; then
        restore_fun(){
            cat extensions.txt | xargs -L 1 code --install-extension
            clear
        }
        restore_fun
        echo "$count_extensions Extensions restored"

        # undo the the extension.txt and rollback to the backup
        undo_restore_fun(){
            echo
            read -p "Do you want to undo the installation of extensions.txt and rollback to the previous backup? (y/n) " undo_restore

            if [ "$undo_restore" = "y" ]; then
                rm extensions.txt
                mv extensions.txt.bak extensions.txt
                restore_fun
                echo "Rolled-back successfully & installed the previous extensions list"
            elif [ "$undo_restore" = "n" ]; then
                echo "Extensions.txt not rolled back">/dev/null
            else
                echo "Invalid input, Please enter y or n"
                undo_restore_fun
            fi
        }
        undo_restore_fun
    
    else
        clear
        echo "Invalid input, Please enter b or r"
        backup_restore
    fi
}
backup_restore