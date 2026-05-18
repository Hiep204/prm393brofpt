//Trong ví dụ này, em sử dụng Stream để phát ra nhiều giá trị theo thời gian. 
//Hàm countStream() dùng async* để tạo Stream và dùng yield để phát ra từng số từ 1 đến 5. 
//Trong main(), em dùng await for để lắng nghe từng giá trị trong Stream và in ra console. 
//Ví dụ này cho thấy Stream phù hợp với dữ liệu thay đổi liên tục hoặc dữ liệu được gửi nhiều lần.