using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Nethereum.Web3;


public class Web3Initializer : MonoBehaviour
{
    public static Web3 Web3Instance;

    void Start()
    {
        Web3Instance = new Web3("https://rpc.sepolia.dev/");
    }
}

