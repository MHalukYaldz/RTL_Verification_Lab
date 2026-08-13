`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Part1_5();

    /*
		always_comb begin
			// Combinational logic
		end
		
		always_ff @(posedge clk) begin
			// Sequential logic
		end
		
		always_latch begin
			// Latch logic
		end
	*/

endmodule
/*
Kombinasyonel devre icin always_comb kullanilir. Bu yapida cikislar mevcut girdilere
bagli olarak belirlenir ve clock sinyaline ihtiyac duyulmaz. always_comb kullanildiginda
blok icinde okunan sinyaller sensitivity listesine otomatik olarak dahil edilir.
Kombinasyonel mantik tanimlanirken tum kosullarda cikislara deger atanmasina dikkat
edilmelidir. Aksi halde istenmeyen latch olusabilir. Bu nedenle kombinasyonel mantik
taniminda cikislarin gerekli tum kosullarda atanmasi gerekir.

always_ff, flip-flop gibi sirali mantik yapilarini tanimlamak icin kullanilir.
Blok genellikle posedge veya negedge gibi belirli bir clock kenarinda calisir.
Ornegin always_ff @(posedge clk) yapisinda blok, clk sinyalinin yukselen kenarinda
tetiklenir. Asenkron reset kullanilmasi durumunda reset kenari da event control
ifadesine eklenebilir. Sirali tasarimlarda clock ve reset sinyallerinin zamanlamasi
onemlidir. Setup, hold ve diger timing gereksinimleri tasarimda dikkate alinmalidir.

Latch uygulamak icin always_latch kullanilir. Latch seviye duyarlidir. Belirlenen
enable veya kosul aktifken giristeki degisim cikisa yansiyabilir, kosul aktif degilken
ise cikis onceki degerini korur. Bu nedenle latch tanimlanirken kosullarin dikkatli
bir sekilde belirlenmesi gerekir. Kombinasyonel mantik tasarlarken eksik assignment
nedeniyle istenmeden latch olusmamasina da dikkat edilmelidir.

Testbench kodunda always_comb, always_ff ve always_latch kullanimi testbench'in
ihtiyacina gore degisir. Test edilen DUT'un kombinasyonel, sirali veya latch icermesi
testbench tarafinda ayni procedural yapinin kullanilmasini zorunlu kilmaz.

Testbench icinde always_comb kullanilabilir. Genellikle testbench icindeki
kombinasyonel yardimci mantiklari tanimlamak icin kullanilabilir. Test edilen DUT'un
kombinasyonel olmasi testbench'te always_comb kullanilmasini zorunlu kilmaz.

Testbench icinde always_ff kullanilabilir ancak sirali bir DUT'u test etmek icin
always_ff kullanmak zorunlu degildir. Clock uretimi genellikle always blogu ile,
stimulus ise initial, task veya class tabanli yapilarla gerceklestirilebilir.

Testbench icinde always_latch kullanilabilir ancak DUT'un latch icermesi testbench'te
always_latch kullanilmasini gerektirmez. always_latch, testbench icinde gercekten
latch davranisi gosteren yardimci bir mantik tanimlanmak istendiginde kullanilabilir.

Sensitivity list kullanimi procedural blogun turune baglidir. always_comb
kullanildiginda blok icinde okunan sinyaller sensitivity listesine otomatik olarak
dahil edilir. always @(*) yapisinda da ilgili sinyaller otomatik olarak belirlenir.
Normal bir always blogunda ise gerekli event control veya delay acikca
belirtilmelidir. Ornegin clock uretimi icin:

always #5 clk = ~clk;

kullanilabilir.

Kombinasyonel mantikta always @(*) veya always_comb blogu ilgili girdiler
degistiginde yeniden degerlendirilir. Sirali mantikta ise blok genellikle belirtilen
clock kenarinda, ornegin posedge clk veya negedge clk olayinda tetiklenir.

Testbench kodunda amac sadece uyarici (stimulus) olusturmak degildir. DUT'a uyarici
uygulamanin yaninda DUT'un cikislarini gozlemlemek ve elde edilen sonuclari kontrol
etmek de testbench'in temel gorevlerindendir.
*/
