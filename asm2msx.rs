//
// Title: asm2msx.rs
// Creation date: May 08, 2023
// Revision: 0.20
// Creator: Minoru Kishi (Twitter:MIN0_KABE)

use std::fs::File;
use std::io::{Read, Write, BufReader};
use std::env;

fn str_hex(bytes: &[u8]) -> String {
     bytes.iter().fold("".to_owned(), |s, b| format!("{}{:>02x}", s, b) )
}

fn main() -> Result<(), Box<dyn std::error::Error>> {

	let _res3: u8 = 0;
	let mut head1: u32 = 1000;
	let mut str1: String = format!("{:>04} {} ", head1, "data");
	let mut c: u8 = 0;
	let cmax: u8 = 20;
	let dat_lf: u8 = 0x0a;
    let str0 = r#"
1 clear 100,&hd000
2 k=&hd000:def usr=k
3 read x$:if x$="end" then 8
4 if x$="" then 3
5 x2$=left$(x$,2):x$=right$(x$,len(x$)-2)
6 y=val("&h"+x2$):poke k,y:k=k+1
7 goto 4
8 a=usr(0):end
"#.trim();

	let args: Vec<String> = env::args().collect();
	if args.len() < 3 {
		println!("\nUsage: asm2msx.exe <source file name> <destination file name>\n");
    }
    let source = &args[1];
    let dest = &args[2];

    for res in BufReader::new(File::open(source)?).bytes() {
		match res {
			Err(_) => eprintln!("Error: File::open({})", source),
			Ok(_) => (),
		}
		let res3 = res?;
		if c > cmax {
			str1 += std::str::from_utf8(&[dat_lf]).unwrap();
			c = 0;
			head1 += 10;
			str1 += &format!("{:>04} {} ", head1, "data");
		}else{
			c += 1;
		}
		str1 += &str_hex(&[res3]);
    }

	if &str1[..1] != std::str::from_utf8(&[dat_lf]).unwrap() {
		str1 += std::str::from_utf8(&[dat_lf]).unwrap();
	}

	head1 += 10;
	str1 += &format!("{:>04} {} ", head1, "data end");
	str1 += std::str::from_utf8(&[dat_lf]).unwrap();

	let str2 = str0.to_owned() + std::str::from_utf8(&[dat_lf]).unwrap();
	let str3 = &str2;
	
	let file = File::create(dest);
	let file = write!(file?, "{}", str3.to_owned() + &str1);
	match file {
		Err(_) => eprintln!("Error: File::create({})", dest),
		Ok(_) => (),
	}

    Ok(())
}
