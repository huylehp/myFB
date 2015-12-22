# myFb app
- App yêu cầu user đăng nhập bằng tài khoản facebook. (Tài khoản này sẽ được lưu lại, user không cần đăng nhập lai cho lần chạp app tiếp theo cho đến khi tài khoản hiện tại được logout).

- Sau khi đăng nhập, app sẽ chuyển sang màn hình hiển thị tab bar controller bao gồm 2 item: newFeed và Update.

* newFeed: + Hiển thị một tableView chứa thông tin về feed của trang Facebook cá nhân.
	   + Mỗi cell bao gồm thông tin: username, user active, user image, feed image, status (nếu có).
	   + tableView có sử dung autolayout để tuỳ biến độ cao của từng cell cũng như khi thay đổi hướng của thiết bị. 
	   + Nếu cell đó chứa ảnh: khi nhấn vào man hình sẽ push ra một trang hiển thị ảnh. Người dùng có thể phóng to thu nhỏ ảnh. Ngược lại thì không.
	   + Số lượng feed hiển thị ban đầu là 10. Ở cuối tableView có chứa cell: “Load more…”.Khi ấn vào, feed tableView sẽ load thêm 10 cell. Cứ như vậy cho đến khi tất cả feed được hiển thị.
	   + Button “logout” để người dùng đăng xuất tài khoản fb.

* Update: + Hiển thị các chức năng của người dùng tương tác với newFeed:
	1. Đăng status mới
	2. Đăng một bức ảnh (ảnh mặc định fixed) .
	3. Truy xuất vào album ảnh, lấy ảnh bất kỳ và đăng lên newFeed;
	4. Chụp ảnh và đăng ảnh lên newFeed;
	  + Sau mỗi một tác vụ, màn hình hiển thị sẽ chuyển sang tab newFeeds để hiển thị những update đó.