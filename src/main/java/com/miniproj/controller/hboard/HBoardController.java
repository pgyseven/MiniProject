package com.miniproj.controller.hboard;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.catalina.connector.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.service.hboard.HBoardService;
import com.miniproj.util.FileProcess;
//import java.lang.* //생략 java lang패키지는 기본 패키지
// Controller 단에서 해야 할 일
// 1) URI 매핑(어떤 URI가 어떤 방식으로(GET/Post)으로 호출 되었을 때 어떤 메서드에 매핑 시킬 것이냐
// 2) 있다면 view 단에서 보내준 매개변수 수집
// 3) 데이터베이스에 대한 CRUD 를 수행하기 위해 service단의 해당 메서드를 호출. service단에서 rerutn 갑을 view 바인딩 view 호출
// 4) 부가적으로... 컨트롤러 단은 servlet에 의해 동작되는 모듈이기 때문에 HttpServletRequest, HttpServletReponse,HttpSession
// 등의 Servlet 객체들을 이용할 수 있다 -> 이러한 객체들을 이용하여 구현할 기능이 있다면 그 기능은 Controller 단에서 구현한다.(참고로 리퀘스트는 한번 하면 사라지지만 세션은 유저마다 하나씩 생긴다. 유저가 떠날때까지 유지) 서비스단 이후는 서블릿이 아니라 리퀘스트 세션 불러올수 없다 그래서 컨트롤러 단에서만 이걸 불러오는건 다 해야한다.

@Controller // 아래의 클래스가 컨트롤러 객체임을 명시
@RequestMapping("/hboard")
public class HBoardController {
	// Log를 남길 수 있도록 하는 객체
	private static Logger logger = LoggerFactory.getLogger(HBoardController.class);

	@Autowired
	private HBoardService service; // 상속 받았기 때문에 부모가 HBoard 다

	@Autowired
	private FileProcess fileProcess;
	
	//아래서 지역변수에 의해 안날아가고 유저가 저장누르기 전까지 파일 정보 가지고 있게 하기 이걸 만든다.
	@Autowired
	private List<BoardUpFilesVODTO> uploadFileList = new ArrayList<BoardUpFilesVODTO>();  // 이게 스테이틱하면 모든 객체가 공유하니깐 다른 사람도 올린것처럼 될수도???
	
	// 게시판 전체 목록 리스트를 출력하는 메서드
	@RequestMapping("/listAll")
	public void listAll(Model model) {
		logger.info("HBoardController.listAll()~");

		// 서비스 단 호출
		List<HBoardVO> list = null;
		try {
			list = service.getAllBoard();
			model.addAttribute("boardList", list);
		} catch (Exception e) {
			model.addAttribute("exception", "error");
		}

//      for(HBoardVO b : list) {
//			System.out.println(b.toString());
//		}
		// model.addAttribute("boardList", list); //바이터 파인딩
		// return "/hboard/listAll.jsp";
		// /hboard/listAll.jsp 으로 포워딩 됨
	}

	// 게시판 글 저장 페이지를 출력하는 메서드
	@RequestMapping("/saveBoard")
	public String showSaveBoardForm() {
		return "/hboard/saveBoardForm";
	}

	// 게시글 저장 버튼을 눌렀을때 해당 게시글을 db에 저장하는 메서드
	@RequestMapping(value = "/saveBoard", method = RequestMethod.POST) /* url 호출이름이 위와 같은데 전송방식이 다르기 때문에 문제 없다 */
	public String saveBoard(HBoardDTO boardDTO, RedirectAttributes redirectAttributes) {
		System.out.println("이게시글을 출력하자...................." + boardDTO.toString()); // "/saveBoard 보이드는 이거에 의해서 .jsp 가
																					// 붙어서 간다.
		
		String returnPage = "redirect:/hboard/listAll";
		try {
			if (service.saveBoard(boardDTO)) { // 게시글 저장에 성공했다면
				redirectAttributes.addAttribute("status","success");
			}
		} catch (Exception e) { // 게시글 저장에 실패했다면
			e.printStackTrace();
			redirectAttributes.addAttribute("status","fail");
		}
		// VO는 리드 온리로서 디비에 꺼내온걸 저장해서 앞단까지 가져가는 것 즉 뷰단까지 즉 DTO와 VO가 다른거다 같이 쓰기도 하는데 앞단
		// 뷰단은 자주 바뀔수 있다. 그래서 따로 쓰는게 좋다.
		
		return returnPage; //게시글 전체 목록 페이지로 돌아감
	}
	
	@RequestMapping(value="/upfiles", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8;") // application/json이걸보고 페이지 이동을 안해도 되겠구나 한다. / 요청처리를 제이슨으로 하겠다. produces 리퀘스트 매핑을 처리하는 방식 우린 제이슨으로 할거임
	public ResponseEntity<String> saveBoardFile(@RequestParam("file") MultipartFile file, HttpServletRequest request) { // file 이라고 했는데 못찾을때가 있다 그래서 @RequestParam("file") 이걸 넣었다. / 컨트롤단 즉 서블릿단이다 여기는 리퀘스트가 있는곳
		// ResponseEntity<>  http status 서로 상태를 주고 받음 통신은~ 받을 준비 보낼준비까지도 요청의 성공 여부를 나타내는 상태코드   참고로 나중에 하겠지만 레스트 방식은 제이슨 형태고 주고 받음
		System.out.println("파일 전송됨... 이제 저장해야함...");
		
		ResponseEntity<String> result = null;
		
		String contentType = file.getContentType(); // 마인 타입?
		String originalFileName = file.getOriginalFilename();
		long fileSize = file.getSize();
		byte[] upfile = null;
		try {
			upfile = file.getBytes();//2진파일의 파일 내용 즉 실제 파일 IO익셉션 뜸 하드디스크 내용을 읽을때 하드디스크가 말성이면 못 읽을테니~ 예외처리 여기서 못하니 에드 뜨로우로 컨트롤단으로 보낸다.
			// 저장될 파일의 실제 contents
			
			String realPath = request.getSession().getServletContext().getRealPath("/resources/boardUpFiles");
			
			BoardUpFilesVODTO fileInfo = fileProcess.saveFileToRealPath(upfile, realPath, contentType, originalFileName, fileSize); //지역변수라서 파일 여러개 올리면 오버라이드 된다.
			
			//System.out.println("저장된 파일의 정보" + fileInfo.toString());
			
			this.uploadFileList.add(fileInfo);
			
			// 7월 17일 가장 먼저 해야 할 코드 : front에서 업로드한 파일을 지웠을때 백엔드에서도 지워야 한다.
			System.out.println("===================================================");
			System.out.println("현재 파일 리스트에 있는 파일들");
			for (BoardUpFilesVODTO f : this.uploadFileList)
				System.out.println(f.toString());
			System.out.println("===================================================");
			
			result = new ResponseEntity<String>("success", HttpStatus.OK); //이넘타입(컨트롤 스페이스 누르면 뜨는 아이콘)은 점 찍고 나오는 상수의 값만 받을수 있는 
			
			
		} catch (IOException e) {
			
			e.printStackTrace();
			result = new ResponseEntity<String>("fail", HttpStatus.NOT_ACCEPTABLE);
		}
		
		
		return result;
		
	}
	
	
}
