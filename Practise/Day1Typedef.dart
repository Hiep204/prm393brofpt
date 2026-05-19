// Typedefs trong Dart là một cách ngắn gọn để tạo ra các alias  (bí doanh)
// trong cách loại dữ liệu . Điều này giúp mã nguồn trở nên rõ ràng and dễ đọc hơn
//, đặc biệt là khi làm việc với loại dữ liệu phức tạp
typedef TinhToan = int Function(int a, int b);
int cong(int a, int b) {
  return a + b;
}

int tru(int a, int b) {
  return a - b;
}

void main() {
  TinhToan phepTinh;

  phepTinh = cong;
  print(phepTinh(5, 3));

  phepTinh = tru;
  print(phepTinh(5, 3));
}
