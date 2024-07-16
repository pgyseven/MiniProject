package com.miniproj.util;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Calendar;

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.miniproj.model.BoardUpFilesVODTO;

@Component    // 스프링 컨테이너에게 객체를 만들어 관리하도록 하는 어노테이션 루트다시 컨텍스트 확인
public class FileProcess {
	
	// file을 realpath에 저장하는 메소드
	public BoardUpFilesVODTO saveFileToRealPath(byte[] upfile, String realPath, String contentType, String originalFileName, long fileSize) throws IOException  {
		BoardUpFilesVODTO result = null;
		

		
		
		
		// 파일이 실제 저장되는 경로 realPath +"/년/월/일" 경로
		String[] ymd = makeCalendarPath(realPath);
		makeDirectory(realPath, ymd);
		
		
		String saveFilePath = realPath + ymd[ymd.length - 1]; //실제 파일의 저장 경로
		
		String newFileName = null;
		String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
		if(fileSize > 0) {
			if(checkFileExist(saveFilePath, originalFileName)) { // 파일 이름이 중복 되는지 검사 중복 된다면, 파일 이름 변경
				newFileName = renameFileName(originalFileName);
				
				
				
			}else {
				newFileName = originalFileName;
			}
			
			
			if(ImageMimeType.isImage(ext)) {
				//이미지 파일임 -> 썸네일 이미지, base64 문자열을 만들고 이미지와 함께 저장해야 한다.
			}else {
				// 이미지 파일이 아니다. 그냥 현재 파일만 하드디스크에 저장하면 된다.
				File saveFile = new File(saveFilePath + File.separator + newFileName);
				FileUtils.writeByteArrayToFile(saveFile, upfile); // 실제 파일 저장 / pom.xml 에 라이브러리 추가해서 메이븐에 coomons fileupload 1.3.3 jar 
				
				
				result = BoardUpFilesVODTO.builder()
						.ext(contentType)
						.newFileName(newFileName)
						.originalFileName(originalFileName)
						.size(fileSize)
						.build(); //객체가 만들어진다.
				
			}
			
		}
		
		
		
		return result; //저장된 파일의 정보를 담은 객체
	}
	
	
	
	
	
	
	
	// 파일 이름 바꾸는 메서드 
	// 예 : originalFileName_timestamp.확장자 타임스탬프는 1970년 부터 지금까지 흘러온 시간을 정수화 한거!
	private String renameFileName(String originalFileName) {
		String timestamp = System.currentTimeMillis() + "";    // ""이걸로 문자화 long은 정수다 시스템은 컴퓨터 자체다.
		
		String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1); //substring(a,b) a이상 b 미만 한개만 쓰면 거기 부터 끝까지
		String fileNameWithOutExt = originalFileName.substring(0, originalFileName.lastIndexOf(".")); // .는 미만이니깐 포함 안됨
		
		String newFileName = fileNameWithOutExt + "_" + timestamp + "." + ext;
		System.out.println("올드 파일 네임 : " + originalFileName ); //new.png
		System.out.println("새로운 파일 이름 :" + newFileName); //new_1721111043830.png
		return newFileName;
	
	}








	// originalFileName 이 saveFilePath 에 존재하는지 안하는지..(파일 중복 여부) / 이렇게 안하고 인덱스 오브를 쓰면 된다 근데 만들었으니 그냥 쓴다.
	// 중복된 파일이 있다며 true, 없다면 false
	private boolean checkFileExist(String saveFilePath, String originalFileName) {
		File tmp = new File(saveFilePath);
		
		boolean isFind = false;
		String[] dirs = tmp.list();
		if(dirs != null) {
				
		
		for(String name : tmp.list()) { //tmp.list()하나의 배열이다 이게 널일수 있으니 
			if(name.equals(originalFileName)) {
				System.out.println("이름이 같은게 있다.");
				isFind = true;
				break;
			}
		}
		
		}else { //경로에 기존 업로드된 파일이나 폴더가 없을 떄
			return isFind;
		}
		
		if(!isFind) {
			System.out.println("이름이 같은 파일이 없습니다.");
		}
		return isFind;
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
