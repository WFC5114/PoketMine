
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameMang : MonoBehaviour
{
    public AudioSource theMusic;
    public bool startPlaying;

    public ArrowFall arrowFall;

    public static GameMang instance;

    public int currentScore;

    public int scorePerNote = 100;
    public int scorePerGood = 150;
    public int scorePerPerfect = 200;

    public int currentMulti;
    public int multiTrack;
    public int[] multiThresh;


    public Text scoreText;
    public Text multi;
    public float total;
    public float normal;
    public float good;
    public float perfect;
    public float missedA;

    public GameObject result;
    public Text percent, normals, goods, perfects, misses, final;

    // Start is called before the first frame update
    void Start()
    {
        instance = this;

        scoreText.text = "Score: 0";
        currentMulti = 1;

        total = FindObjectsOfType<NoteHit>().Length;

    }

    // Update is called once per frame
void Update()
{
    if (!startPlaying)
    {
        if (Input.anyKeyDown)
        {
            startPlaying = true;
            arrowFall.hasStarted = true;
            theMusic.Play();
        }
    }
    else
    {
        CheckGameOver();
    }
}


    public void hit()
    {

        Debug.Log("Hit on time");
        if (currentMulti - 1 < multiThresh.Length)
        {
            multiTrack++;

            if (multiThresh[currentMulti - 1] <= multiTrack)
            {
                multiTrack = 0;
                currentMulti++;
            }
        }

        multi.text = "Multiplier: x" + currentMulti;

        //currentScore += scorePerNote * currentMulti;

        scoreText.text = "Score: " + currentScore;

    }

    public void normalHit(){
        currentScore += scorePerNote * currentMulti;
        hit();
        normal++;

    }

    public void goodHit(){
        currentScore += scorePerGood * currentMulti;
        hit();
        good++;


    }

    public void perfectHit(){
        currentScore += scorePerPerfect * currentMulti;
        hit();
        perfect++;

    }

    public void missed()
    {
        Debug.Log("Missed!");

        currentMulti = 1;

        multiTrack = 0;

        multi.text = "Multiplier: x" + currentMulti;
        missedA++;


    }

private void CheckGameOver()
{
    if(!theMusic.isPlaying && !result.activeInHierarchy)
    {
        result.SetActive(true);

        normals.text = "" + normal;
        goods.text = good.ToString();
        perfects.text = perfect.ToString();
        misses.text = missedA.ToString();

        float totalHits = normal + good + perfect;
        float percentHit = (totalHits / total) * 100f;

        percent.text = percentHit.ToString("F1") + "%";
        final.text = currentScore.ToString();

        // Determine success
        bool isSuccess = percentHit >= 75; // Example threshold

        // Find the MiniGameController and call EndMiniGame
        MiniGameController miniGameController = FindObjectOfType<MiniGameController>();
        if (miniGameController != null)
        {
            miniGameController.EndMiniGame(isSuccess);
        }
        else
        {
            Debug.LogError("MiniGameController not found in the scene!");
        }
    }
}


}
