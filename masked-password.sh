read -s -p "Enter your new password: " password
masked_password=$(echo "$password" | sed 's/./*/g')
echo ""
echo "your password is : $masked_password"
