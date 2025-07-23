#ifndef I2C_UTILS_H
#define I2C_UTILS_H

void i2c1_scan(void);
void i2c2_scan(void);
void i2c2_scan_and_read_id(void);
void test_lps22hh_whoami(void);

#endif // I2C_UTILS_H 