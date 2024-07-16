package com.miniproj.util;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Calendar;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.miniproj.model.BoardUpFilesVODTO;

@Component    // 스프링 컨테이너에게 객체를 만들어 관리하도록 하는 어노테이션 루트다시 컨텍스트 확인
public class FileProcess {
	
	// file을 realpath에 저장하는 메소드
	public BoardUpFilesVODTO saveFileToRealPath(byte[] upfile, String realPath, String ext, String originalFileName, long fileSize)  {
		BoardUpFilesVODTO result = null;
		

		
		
		
		// 파일이 실제 저장되는 경로 realPath +"/년/월/일" 경로
		String[] ymd = makeCalendarPath(realPath);
		makeDirectory(realPath, ymd);
		
		
		return result;
	}
	// 파일이 저장될 경로의 디렉토리 구조를 "/년/월/일" 형태로 만드는 메서드
	private String[] makeCalendarPath(String realPath) {
		Calendar now = Calendar.getInstance();  // 현재 날자 시간 객체
		String year = File.separator + now.get(Calendar.YEAR) + ""; // \2024 나옴 / 스트링과 인트의 결합이라 인트에 ""를 합쳐주면 된다. / 우린 ms 라서 파일 구분은 역슬레시 그러나 서버들은 리눅스인데 리눅스는 슬레시이다. file.separator는 그걸 is 맞게 알아서 해준다.
		String month = year + File.separator + new DecimalFormat("00").format(now.get(Calendar.MONTH)+1);  // \2024\07 나옴 / decimal 10진으로 만들어주는 객체 00으로 하면 앞에서 7이 나오면 00 형태로 만들기 위해 07이 됌 즉 이 형태로 맞추라는 것 / 컴터는 1월을 시작월이라하여 0부터 시작해서 1을 더한다.
		String date = month + File.separator + new DecimalFormat("00").format(now.get(Calendar.DATE));// \2024\07\16(오늘날쨔) 나옴
		System.out.println(year + month + date);
		
		String[] ymd = {year, month, date};
		return ymd;
		
		
	}

	// 실제 directory를 만드는 메서드
	// 가변인자 메서드(전달된 year, month, date의 값이 ymd 하나의 배열로 처리
	private void makeDirectory(String realPath, String[] ymd) { //String...ymd ... 가변인자 배열 형태로 들어옴 year은 0번째 배열 순서대로 1번은 월 2번은 일 배열이름은 ymd로 지정
		
		if (!new File(realPath + ymd[ymd.length - 1]).exists()) { //exists 디렉토리 유무 확인
			//디렉토리 생성해야함
			
			for (String path : ymd) {
				File tmp = new File(realPath + path); //realPath + \2024 다음번 포문 돌때 \07 다음 포문 돌때 \16 묻고 없음 만들고 이런형식
			if (!tmp.exists()) {
				tmp.mkdir();
				
			}
			}
			
		}
		
	}

}
